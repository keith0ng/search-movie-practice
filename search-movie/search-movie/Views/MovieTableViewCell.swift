//
//  MovieTableViewCell.swift
//  search-movie
//
//  Created by Keith Samson on 12/2/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImag: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
