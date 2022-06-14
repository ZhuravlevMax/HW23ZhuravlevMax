//
//  ImageCollectionViewCell.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 1.06.22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let key = "ImageCollectionViewCell"

    @IBOutlet weak var collectionImageView: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()

        collectionImageView.layer.cornerRadius = 10
    }
    override var isSelected: Bool {
        didSet {
            setSelectedAttribute(isSelected: isSelected)
        }
    }
    func setSelectedAttribute(isSelected: Bool) {
        
        if isSelected {
        collectionImageView.layer.masksToBounds = true
        collectionImageView.layer.borderWidth = 1.5
        collectionImageView.layer.borderColor = UIColor.red.cgColor
        } else {
            collectionImageView.layer.masksToBounds = true
            collectionImageView.layer.borderWidth = 0
            collectionImageView.layer.borderColor = UIColor.white.cgColor
        }
    }

}
