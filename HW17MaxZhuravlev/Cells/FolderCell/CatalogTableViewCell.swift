//
//  catalogTableViewCell.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 25.05.22.
//

import UIKit
import SnapKit

class CatalogTableViewCell: UITableViewCell {
 
    @IBOutlet weak var catalogCellLabel: UILabel!
    
    @IBOutlet weak var catalogCellImage: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var selecteCatalogImageView: UIImageView!
    
    static let key = "CatalogTableViewCell"
    
    var barButtonCondition: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        catalogCellImage.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(16)
            make.height.width.equalTo(20)
        }
        catalogCellLabel.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview().inset(16)
            make.left.equalTo(catalogCellImage.snp.right).offset(8)
        }
        selecteCatalogImageView.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview().inset(16)
        }
        selecteCatalogImageView.isHidden = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isSelected ? (selecteCatalogImageView.isHidden = false) : (selecteCatalogImageView.isHidden = true)
        cellView.backgroundColor = isSelected ? .white : .white

        // Configure the view for the selected state
    }
    
    
    
}
