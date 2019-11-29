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
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchButtonTapped(searchBar: UISearchBar) {
        
    }
    
    func searchBarDidBeginEditing(searchBar: UISearchBar) {
        
    }
}
