//
//  SnapCell.swift
//  SnapchatClone
//
//  Created by Messiah on 11/13/23.
//

import UIKit
import SDWebImage

class SnapCell: UICollectionViewCell {

    @IBOutlet weak var snapImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Additional configuration if needed
    }

    func configureCell(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            snapImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: { (image, error, cacheType, imageURL) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                } else {
                    print("Image loaded successfully")
                }
            })
        } else {
            print("Invalid URL for image: \(imageUrl)")
        }
    }
}
