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

    }

}
