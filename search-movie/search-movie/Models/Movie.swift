//
//  Movie.swift
//  search-movie
//
//  Created by Keith Samson on 11/29/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import Foundation

// Use codable to easily parse json responses from the API
// as long as the name of the json key matches the variable name
struct Movie: Codable {
    var id: Int?
    var title: String?
    var overview: String?
    var release_date: String?
    var vote_average: Double?
    var poster_path: String?
}
