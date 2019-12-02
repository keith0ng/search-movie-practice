//
//  MovieListViewController.swift
//  search-movie
//
//  Created by Keith Samson on 11/29/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListViewController: UIViewController {

    var mainView: MovieListView?
    
    var movieArray: [Movie]? = [] {
        didSet {
            DispatchQueue.main.async {
                self.mainView?.tableView.reloadData()
            }
        }
    }
    
    var searchKeyword: String?
    var currentPage: Int = 1
    var totalPage: Int = 0
    
    private var isRequesting: Bool = false
    
    override func loadView() {
        mainView = MovieListView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView?.tableView?.delegate = self
        mainView?.tableView?.dataSource = self
        mainView?.tableView?.estimatedRowHeight = 335.0
        mainView?.tableView?.rowHeight = UITableView.automaticDimension
        
        let movieCell = UINib(nibName: "MovieTableViewCell", bundle: nil)
        mainView?.tableView?.register(movieCell, forCellReuseIdentifier: "MovieTableViewCellReuseIdentifier")
        getSearchResults(keyword: searchKeyword, page: currentPage)
    }
    
    private func getPosterPath(posterPath: String?) -> String {
        return "https://image.tmdb.org/t/p/original/\(posterPath ?? "")"
    }
    
    private func getSearchResults(keyword: String?, page: Int) {
        // Use a better API request especially on projects with several endpoints. Alamofire is the most common.
        // For simplicity, use the URL Session.
        
        
        let url = "https://api.themoviedb.org/3/search/movie?api_key=4b951e36d117bbc88ac54eccece53258&query=\(keyword ?? "")&page=\(page)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            let movieResult = self.getMovieResult(data: data)
            self.totalPage = movieResult?.total_pages ?? 0
            self.currentPage = page
            
            let moviesFromData = movieResult?.results
            self.movieArray?.append(contentsOf: moviesFromData ?? [])
            
            self.isRequesting = false
        })
        
        isRequesting = true
        task.resume()
    }
    
    
    private func getMovieResult(data: Data?) -> GetMovieResult? {
        if let _ = data {
            do {
                var movieResult: GetMovieResult
                try movieResult = JSONDecoder().decode(GetMovieResult.self, from: data!)
                return movieResult
            } catch {
                return nil
            }
        }
        return nil
    }

}

extension MovieListViewController: UITableViewDelegate {
    
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCellReuseIdentifier") as? MovieTableViewCell {
            let row = indexPath.row
            let movie = movieArray?[row]
            movieCell.titleLabel.text = movie?.title
            movieCell.dateLabel.text = movie?.release_date == "" ? "-" : movie?.release_date
            movieCell.ratingLabel.text = "\(movie?.vote_average ?? 0.0)"
            movieCell.overviewLabel.text = movie?.overview
            
            let posterURL = URL(string: getPosterPath(posterPath: movie?.poster_path ?? ""))
            movieCell.posterImage.sd_setImage(with: posterURL, completed: nil)
            
            return movieCell
        }
        
        
        return UITableViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isRequesting {
            // To handle multiple request when scrollig down multiple times in fast succession.
            return
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 10.0 {
            print("Table scrolled to bottom")
            let nextPage = currentPage + 1
            if nextPage <= totalPage {
                getSearchResults(keyword: searchKeyword, page: nextPage)
            }
        }
    }
}
