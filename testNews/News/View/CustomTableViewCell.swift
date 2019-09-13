//
//  CustomTableViewCell.swift
//  testNews
//
//  Created by Kanat Kuanyshbek on 9/13/19.
//  Copyright © 2019 Kanat Kuanyshbek. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageOfNews: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageURL: URL?
    var imageTo: UIImage? {
        get {
            return imageOfNews.image
        }
        set {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageOfNews.image = newValue
        }
    }
    
}
