//
//  ViewController.swift
//  search-movie
//
//  Created by Keith Samson on 11/29/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var mainView: SearchView?
    var recentSearches:[String]?
    
    override func loadView() {
        mainView = SearchView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView?.delegate = self
        
        mainView?.tableView.delegate = self
        mainView?.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        recentSearches = userDefaults.stringArray(forKey: "RecentSearchKey")
    }
}


// MARK: - Helper Methods
extension SearchViewController {
    
    private func showMovieList(searchString: String) {
        mainView?.tableView.isHidden = true
        mainView?.movieSearchBar.resignFirstResponder()
        
        let movieListVC = MovieListViewController()
        movieListVC.searchKeyword = searchString
        navigationController?.pushViewController(movieListVC, animated: true)
        
        mainView?.movieSearchBar.text = ""
    }
    
    private func showErrorAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {
    func searchButtonTapped(searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty)! {
            showErrorAlert(message: "Please enter a keyword")
            return
        }
        showMovieList(searchString: searchBar.text ?? "")
    }
    
    func searchBarDidBeginEditing(searchBar: UISearchBar) {
        mainView?.tableView.reloadData()
        mainView?.tableView.isHidden = false
    }
    
    func searchBarCencelButtonTapped(searchBar: UISearchBar) {
        mainView?.tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        showMovieList(searchString: recentSearches?[row] ?? "")
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellReuseIdentifier")
        let row = indexPath.row
        cell.textLabel?.text = recentSearches?[row]
        return cell
    }
}
