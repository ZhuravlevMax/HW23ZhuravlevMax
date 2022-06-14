//
//  CollectionViewCell.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 1.06.22.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainCellView: UIView!
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var collectionViewLabel: UILabel!
    
    var mainCellColor = UIColor(ciColor: .cyan)

    
    override var isSelected: Bool {
        didSet {
            setSelectedAttribute(isSelected: isSelected)
        }
    }
    
    func setSelectedAttribute(isSelected: Bool) {
        
        self.mainCellView.backgroundColor = isSelected ? .yellow : .cyan
    }
    
    static let key = "CollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()

        mainCellView.backgroundColor = mainCellColor
        mainCellView.layer.cornerRadius = 10
        // Initialization code
    }
    
    

}
