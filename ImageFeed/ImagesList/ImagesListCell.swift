//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by oneche$$$ on 26.03.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageInCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
}
