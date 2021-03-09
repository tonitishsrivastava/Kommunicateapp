//
//  ImageCollectionViewCell.swift
//  Kommunicate app
//
//  Created by Nitish Srivastava on 09/03/21.
//

import UIKit
import SkeletonView
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    func setupData(imageData: ImageData, completionHandler: @escaping (_ image: UIImage?) -> Void){
        let url = URL(string: imageData.smallUrl!)!
        self.postImageView.showAnimatedGradientSkeleton()
        self.imageHeight.constant = UIScreen.main.bounds.height/3
        self.postImageView.kf.setImage(with: url, completionHandler : { image, error, cacheType, imageURL in
            self.postImageView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            self.postImageView.contentMode = .scaleToFill
            self.postImageView.layer.cornerRadius = 8
            self.postImageView.clipsToBounds = true
            completionHandler(image)
        })
    }
    
    
}
