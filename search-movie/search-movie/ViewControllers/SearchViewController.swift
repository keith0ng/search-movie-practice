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

extension SearchViewController: SearchViewDelegate {
    func searchButtonTapped(searchBar: UISearchBar) {
        mainView?.tableView.isHidden = true
        searchBar.resignFirstResponder()
        let movieListVC = MovieListViewController()
        movieListVC.searchKeyword = searchBar.text
        navigationController?.pushViewController(movieListVC, animated: true)
        
        searchBar.text = ""
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView?.tableView.isHidden = true
        mainView?.movieSearchBar.resignFirstResponder()
        let movieListVC = MovieListViewController()
        let row = indexPath.row
        movieListVC.searchKeyword = recentSearches?[row]
        navigationController?.pushViewController(movieListVC, animated: true)
    }
}

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
