//
//  BallOne.swift
//  BarBreaker
//
//  Created by Viktor on 13/09/16.
//  Copyright © 2016 viggurt. All rights reserved.
//

import SpriteKit

class BallOne: SKSpriteNode {
 
    init(){
        
        let size = CGSize(width: 100, height: 100)
        let texture = SKTexture(imageNamed: "ball1")
        
        super.init(texture: texture, color: UIColor.blackColor(), size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: 25)
        physicsBody?.affectedByGravity = true
        physicsBody?.restitution = 0.6
        physicsBody?.linearDamping = 0.8
        physicsBody?.angularDamping = 0.9
        physicsBody!.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody!.categoryBitMask = GameScene.PhysicsCategory.Ball1
        physicsBody!.collisionBitMask = GameScene.PhysicsCategory.Ball1 | GameScene.PhysicsCategory.Ball2
        physicsBody!.contactTestBitMask = GameScene.PhysicsCategory.Ball1 | GameScene.PhysicsCategory.Ball2
        
    }
    
}
