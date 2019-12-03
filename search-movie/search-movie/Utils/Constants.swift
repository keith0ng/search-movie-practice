//
//  Constants.swift
//  search-movie
//
//  Created by Keith Samson on 12/3/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import Foundation

struct Constants {
    
    struct API {
        static let GetMovieURL = "https://api.themoviedb.org/3/search/movie?"
        static let APIKey = "4b951e36d117bbc88ac54eccece53258"
        static let PosterURLPath = "https://image.tmdb.org/t/p/original/"
    }
    
    struct ReuseIdentifier {
        static let MovieTableCell = "MovieTableViewCellReuseIdentifier"
        static let SearchTableCell = "SearchTableViewCellReuseIdentifier"
    }
    
    struct DictionaryKeys {
        static let RecentSearchKey = "RecentSearchKey"
    }
    
    struct ErrorMessages {
        static let ErrorTitle = "Error"
        static let GenericError = "Something went wrong. Please try again."
        static let NoResultsError = "No results found."
        static let EnterKeywordError = "Please enter a keyword."
    }
    
}
