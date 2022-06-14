//
//  ImageViewController.swift
//  HW17MaxZhuravlev
//
//  Created by Максим Журавлев on 29.05.22.
//

import UIKit
import SnapKit
class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var imagesStackView: UIStackView!
    
    var urlForImage: [URL]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myScrollView.delegate = self
        myScrollView.isPagingEnabled = true

        urlForImage.forEach {
            let image = UIImageView(image: UIImage(contentsOfFile: $0.path))
            image.contentMode = .scaleAspectFit
            imagesStackView.addArrangedSubview(image)
            image.snp.makeConstraints { make in
                make.height.equalTo(view.snp.height)
                make.width.equalTo(view.snp.width)
            }
        }
    }
   

}

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imagesStackView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        myScrollView.isPagingEnabled = myScrollView.zoomScale == 1
        
    }
}
