//
//  GetMovieResult.swift
//  search-movie
//
//  Created by Keith Samson on 11/29/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import Foundation
struct GetMovieResult: Codable {
    var results: [Movie]?
    var page: Int?
    var total_pages: Int?
}
