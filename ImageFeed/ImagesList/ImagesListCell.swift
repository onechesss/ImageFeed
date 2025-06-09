//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by oneche$$$ on 26.03.2025.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageInCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageInCell.kf.cancelDownloadTask()
    }

    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(photo: Photo) {
        DispatchQueue.main.async {
           if photo.isLiked {
                self.likeButton.imageView?.image = UIImage(named: "like_button_off")
            }
            else {
                self.likeButton.imageView?.image = UIImage(named: "like_button_on")
            }
        }
        
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
