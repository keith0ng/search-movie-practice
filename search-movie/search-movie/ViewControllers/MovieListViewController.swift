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
        mainView?.tableView?.register(movieCell, forCellReuseIdentifier: Constants.ReuseIdentifier.MovieTableCell)
        getSearchResults(keyword: searchKeyword, page: currentPage)
    }
}


// MARK: - API Request Methods
extension MovieListViewController {
    
    private func getSearchResults(keyword: String?, page: Int) {
        
        mainView?.loadingIndicator.isHidden = false
        // Create a wrapper class for your API requests especially on projects with several endpoints.
        // Alamofire is the most common library used and wrapped for API requests.
        // For simplicity, use the URL Session.
        
        let url = "\(Constants.API.GetMovieURL)api_key=\(Constants.API.APIKey)&query=\(keyword ?? "")&page=\(page)"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            if err != nil { // Handle any type of error. Let the user try the search again
                self.showErrorAlert(message: Constants.ErrorMessages.GenericError)
            } else {
                let movieResult = self.getMovieResult(data: data)
                self.totalPage = movieResult?.total_pages ?? 0
                self.currentPage = page
                
                if let moviesFromData = movieResult?.results, !(moviesFromData.isEmpty) {
                    self.movieArray?.append(contentsOf: moviesFromData)
                    self.saveSearch(keyword ?? "")
                } else {
                    self.showErrorAlert(message: Constants.ErrorMessages.NoResultsError)
                }
            }
            self.isRequesting = false
            DispatchQueue.main.async { self.mainView?.loadingIndicator.isHidden = true }
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
    
    private func getPosterPath(posterPath: String?) -> String {
        return "\(Constants.API.PosterURLPath)\(posterPath ?? "")"
    }
}

// MARK: - Helper Methods
extension MovieListViewController {
    func showErrorAlert(title: String = Constants.ErrorMessages.ErrorTitle, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func saveSearch(_ searchString: String) {
        
        let userDefaults = UserDefaults.standard
        var recentSearchArray = userDefaults.stringArray(forKey: Constants.DictionaryKeys.RecentSearchKey)
        
        if recentSearchArray == nil {
            recentSearchArray = []
        }
        
        recentSearchArray?.removeAll {$0 == searchString}
        
        if (recentSearchArray?.count ?? 0) >= 10 {
            recentSearchArray?.removeLast()
        }
        recentSearchArray?.insert(searchString, at: 0)
        
        userDefaults.set(recentSearchArray, forKey: Constants.DictionaryKeys.RecentSearchKey)
    }
}


// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isRequesting {
            // To handle multiple request when scrollig down multiple times in fast succession.
            return
        }
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 10.0 {
            let nextPage = currentPage + 1
            if nextPage <= totalPage {
                getSearchResults(keyword: searchKeyword, page: nextPage)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movieCell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.MovieTableCell) as? MovieTableViewCell {
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
}
