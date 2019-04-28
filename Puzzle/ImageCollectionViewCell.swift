//
//  ImageCollectionViewCell.swift
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var image: UIImage! {
        didSet {
            imageV.image = image
        }
    }
    private let imageV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        var fix: CGFloat = 10.0
        if AppDelegate.isIPad() || ScreenHeight > 375.0 {
            fix = 40.0
        }
        let cellHeight = (ScreenHeight-AppDelegate.navigationHeight() - fix)*0.5
        imageV.frame = CGRect(x: 0, y: 0, width: cellHeight*1.7, height: cellHeight)
        imageV.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
