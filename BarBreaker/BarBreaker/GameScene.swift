//
//  GameScene.swift
//  BarBreaker
//
//  Created by Viktor on 26/08/16.
//  Copyright (c) 2016 viggurt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "background-football")
    let ball = SKSpriteNode(imageNamed: "ball1")
    let goal = SKSpriteNode(imageNamed: "goal-football")
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let weaponPower: CGFloat = 1500
    let π = CGFloat(M_PI)

    
    override func didMoveToView(view: SKView) {
        
        //Adding the background to the view and setting it to be all the way to the back
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = self.frame.size
        background.zPosition = -1
        addChild(background)
        
        //This checks the background size and prints it in console
        let mySize = background.size
        print("Size: \(mySize)")
        
        //Setting the position of the football and adding it to the view
        ball.position = CGPoint(x: 100 , y: 400)
        ball.size = CGSize(width: 100, height: 100)
        ball.zPosition = 2
        addChild(ball)
        
        //Setting the position of the goal and adding it to the view
        goal.position = CGPoint(x: size.width - 150, y: size.height - size.height + 200)
        goal.size = CGSize(width: 300, height: 400)
        goal.physicsBody = SKPhysicsBody(rectangleOfSize: goal.size)
        goal.physicsBody?.affectedByGravity = false
        goal.physicsBody?.dynamic = false
        addChild(goal)
        
        //This is the gravity in the game
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        //Setting the edges so the ball does not leave the bounds
        let sceneBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        sceneBody.friction = 0
        self.physicsBody = sceneBody
        
        //Positioning the arrow for the launch angle
        arrow.anchorPoint = CGPointMake(0,0.5)
        arrow.zPosition = 1
        arrow.position = ball.position
    }
    
    
    //This function controls which angle you are gonna launch the football at
    func touchStart(touchPoint: CGPoint) {
        let delta = arrow.position - touchPoint
        var angle = delta.angle + π
        
        if angle<0 {
            angle += 2*π
        }
        
        if angle > π/2 && angle < π {
            angle = π/2
        } else if angle > π {
            angle = 0
        }
        
        arrow.zRotation = angle
        
        let arrowsAdded = 0
        
        addChild(arrow)
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let positionOfTouch = touch.locationInNode(self)
            
            /*ball.position = positionOfTouch
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.restitution = 0.8
            ball.physicsBody?.linearDamping = 0
            self.addChild(ball)*/
            
            touchStart(positionOfTouch)
 
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
            touchMoved(touchLocation)
        
    }
    
    func touchMoved(touchPoint: CGPoint) {
        let delta = arrow.position-touchPoint
        var angle = delta.angle + π
        
        if(angle < 0) {
            angle += 2*π
        }
        
        if(angle <= π/2) {
            let rotateAction = SKAction.rotateToAngle(angle, duration: 0)
            arrow.runAction(rotateAction)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        touchStopped(touchLocation)
    }
    
    func touchStopped(touchPoint: CGPoint){
        let angle = arrow.zRotation
        let startingVelocity = CGVectorMake((π/2-angle)*weaponPower, angle*weaponPower)
        arrow.removeFromParent()
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
         ball.physicsBody?.affectedByGravity = true
         ball.physicsBody?.restitution = 0.6
         ball.physicsBody?.linearDamping = 0.8
         ball.physicsBody?.angularDamping = 0.9
         ball.physicsBody?.velocity = startingVelocity
    }
}
