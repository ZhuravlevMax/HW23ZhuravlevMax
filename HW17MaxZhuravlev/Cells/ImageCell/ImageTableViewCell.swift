//
//  ImageTableViewCell.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 28.05.22.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static let key = "ImageTableViewCell"

    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var selecteImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selecteImageView.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isSelected ? (selecteImageView.isHidden = false) : (selecteImageView.isHidden = true)
        //cellView.backgroundColor = isSelected ? .yellow : .white
        // Configure the view for the selected state
        backgroundColor = isSelected ? .yellow : .white
        
        
    }
    
    
}
