//
//  SelectViewController.swift
//  Puzzle
//
//  Created by Youssef on 2018/12/20.
//  Copyright © 2018 Youssef. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    
    var gameImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "选择模式"
        
        self.view.backgroundColor = UIColor.white
        let height: CGFloat = ScreenHeight-AppDelegate.navigationHeight()
        
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        imageV.contentMode = .scaleAspectFit
        imageV.image = UIImage(named: "start")
        self.view.addSubview(imageV)
        
        self.view.addSubview(YSDButton.createHSRedButtonWith(frame: CGRect(x: imageV.frame.maxX+20, y: 100, width: 100, height: 44), Title: "交换模式") { (but) in
            let c = ViewController()
            c.gameImage = self.gameImage
            c.algorithm = 3
            self.navigationController?.present(c, animated: true, completion: nil)
        })
        
        self.view.addSubview(YSDButton.createHSRedButtonWith(frame: CGRect(x: imageV.frame.maxX+20, y: 160, width: 100, height: 44), Title: "自由模式") { (but) in
            let c = FreedomViewController()
            c.gameImage = self.gameImage
            c.algorithm = 3
            self.navigationController?.present(c, animated: true, completion: nil)
        })
    }

}
