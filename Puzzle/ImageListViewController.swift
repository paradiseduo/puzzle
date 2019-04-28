//
//  ImageListViewController.swift
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

class ImageListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let dataArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "选择图片"
        
        let item = UIBarButtonItem()
        item.title = ""
        self.navigationItem.backBarButtonItem = item
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal
        var fix: CGFloat = 10.0
        if AppDelegate.isIPad() || ScreenHeight > 375.0 {
            fix = 40.0
        }
        let cellHeight = (ScreenHeight-AppDelegate.navigationHeight() - fix)*0.5
        layout.itemSize = CGSize(width: cellHeight*1.7, height: cellHeight)
        
        let colloctionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-AppDelegate.navigationHeight()), collectionViewLayout: layout)
        colloctionView.backgroundColor = UIColor.white
        colloctionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCellID")
        colloctionView.delegate = self
        colloctionView.dataSource = self
        self.view.addSubview(colloctionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCellID", for: indexPath) as! ImageCollectionViewCell
        cell.image = UIImage(named: dataArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let c = SelectViewController()
        c.gameImage = UIImage(named: dataArray[indexPath.row]) ?? UIImage()
        self.navigationController?.pushViewController(c, animated: true)
//        let c = ViewController()
//        c.gameImage = UIImage(named: dataArray[indexPath.row]) ?? UIImage()
//        c.algorithm = 3
//        self.navigationController?.present(c, animated: true, completion: nil)
    }
    
}
