//
//  GameViewController.swift
//  ZombieConga
//
//  Created by Viktor on 25/08/16.
//  Copyright (c) 2016 viggurt. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    let point: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size:CGSize(width: 2048, height: 1536), point: point)
        
        let skView = self.view as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
