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
}

extension SearchViewController: SearchViewDelegate {
    func searchButtonTapped(searchBar: UISearchBar) {
        mainView?.tableView.isHidden = true
        searchBar.resignFirstResponder()
        let movieListVC = MovieListViewController()
        movieListVC.searchKeyword = searchBar.text?.lowercased()
        navigationController?.pushViewController(movieListVC, animated: true)
    }
    
    func searchBarDidBeginEditing(searchBar: UISearchBar) {
        mainView?.tableView.isHidden = false
    }
    
    func searchBarCencelButtonTapped(searchBar: UISearchBar) {
        mainView?.tableView.isHidden = true
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView?.movieSearchBar.resignFirstResponder()        
        let movieListVC = MovieListViewController()
        movieListVC.searchKeyword = ""
        navigationController?.pushViewController(movieListVC, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellReuseIdentifier")
        let row = indexPath.row
        cell.textLabel?.text = "Hello, world."
        return cell
    }
}


