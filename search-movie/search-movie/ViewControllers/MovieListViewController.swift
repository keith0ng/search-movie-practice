//
//  MovieListViewController.swift
//  search-movie
//
//  Created by Keith Samson on 11/29/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {

    var mainView: MovieListView?
    
    override func loadView() {
        mainView = MovieListView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getSearchResults()

    }
    
    func getSearchResults() {
        // Use a better API request especially on projects with several endpoints. Alamofire is the most common.
        // For simplicity, use the URL Session.
        let url = "https://api.themoviedb.org/3/search/movie?api_key=4b951e36d117bbc88ac54eccece53258&query=joker&page=1"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            let movieResult = self.getMovieResult(data: data)
            print("## data: \(movieResult)")
        })
        
        task.resume()
    }
    
    
    func getMovieResult(data: Data?) -> GetMovieResult? {
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
