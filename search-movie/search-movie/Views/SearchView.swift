//
//  SearchView.swift
//  search-movie
//
//  Created by Keith Samson on 11/29/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func searchButtonTapped(searchBar: UISearchBar)
    func searchBarDidBeginEditing(searchBar: UISearchBar)
    func searchBarCencelButtonTapped(searchBar: UISearchBar)
}

class SearchView: UIView {
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        let viewFromNib = viewFromOwnedNib()
        addSubviewAndFill(viewFromNib)
        movieSearchBar.delegate = self
    }

}

extension SearchView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchButtonTapped(searchBar: searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.searchBarDidBeginEditing(searchBar: searchBar)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarCencelButtonTapped(searchBar: searchBar)
    }
}
