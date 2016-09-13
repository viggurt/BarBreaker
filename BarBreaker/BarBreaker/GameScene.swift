//
//  GameScene.swift
//  BarBreaker
//
//  Created by Viktor on 26/08/16.
//  Copyright (c) 2016 viggurt. All rights reserved.
//

import SpriteKit

struct game {
    static var IsOver : Bool = false
}

struct physicsCategory{
    static let Ball1: UInt32 = 0
    static let Ball2: UInt32 = 0b1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let background = SKSpriteNode(imageNamed: "background-football")
    let ball = SKSpriteNode(imageNamed: "ball1")
    let ball2 = SKSpriteNode(imageNamed: "ball1")
    let goal = SKSpriteNode(imageNamed: "goal-football")
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let powerBar = SKSpriteNode(imageNamed: "power_bar")
    let powerPin = SKSpriteNode(imageNamed: "power_pin")
    let replay = SKSpriteNode(imageNamed: "replay")
    var points: Int = 0
    
    var weaponPower: CGFloat = 1500
    let π = CGFloat(M_PI)

    
    override func didMoveToView(view: SKView) {
        
        //Adding the background to the view and setting it to be all the way to the back
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = self.frame.size
        background.zPosition = -2
        addChild(background)
        
        //This checks the background size and prints it in console
        let mySize = background.size
        print("Size: \(mySize)")
        
        //Setting the position of the football and adding it to the view
        ball.position = CGPoint(x: 100 , y: 400)
        ball.size = CGSize(width: 100, height: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        ball.zPosition = 2
        
        ball.physicsBody?.categoryBitMask = physicsCategory.Ball1
        ball.physicsBody?.collisionBitMask = physicsCategory.Ball2
        ball.physicsBody?.contactTestBitMask = physicsCategory.Ball2
        ball.name = "Ball1"
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.dynamic = true
        
        addChild(ball)
        
        //Ball2
        //ball2.position = CGPoint(x: size.width - 250, y: size.height - size.height + 450)
        ball2.position = CGPoint(x: 300 , y: 100)

        ball2.size = CGSize(width: 100, height: 100)
        ball2.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        ball2.zPosition = 2
        
        ball2.physicsBody?.categoryBitMask = physicsCategory.Ball2
        ball2.physicsBody?.collisionBitMask = physicsCategory.Ball1
        ball2.physicsBody?.contactTestBitMask = physicsCategory.Ball1
        ball2.name = "Ball2"
        ball2.physicsBody?.affectedByGravity = false
        ball2.physicsBody?.dynamic = true
        
        addChild(ball2)
        
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
        
        replay.position = CGPoint(x: size.width - size.width/size.width - 60, y: size.height - size.height/size.width - 60)
        replay.size = CGSize(width: 100, height: 100)
        replay.name = "restart"
        addChild(replay)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA as! SKSpriteNode
        let secondBody = contact.bodyB as! SKSpriteNode
        
        if ((firstBody.name == "Ball1") && (secondBody.name == "Ball2")){
            collisionBalls(firstBody, Ball2: secondBody)
            points += 1
        }
        else if ((firstBody.name == "Ball2") && (secondBody.name == "Ball1")){
            collisionBalls(secondBody, Ball2: firstBody)
            points += 1
        }
        
    }
    
    func collisionBalls(Ball1: SKSpriteNode, Ball2: SKSpriteNode){
        points + 1
        print("contact")
        
        ball2.physicsBody?.affectedByGravity = true

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
        
        
        addChild(arrow)
        
    }
    
   /* func changeLevel(level: Int) {
        if currentLevel+level < loadLevels()!.count {
            let newScene = GameScene(level: <#T##Int#>)
            newScene.scaleMode = scaleMode
            
            view!.presentScene(newScene)
        }
    }*/
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let positionOfTouch = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionOfTouch)
            
            if let name = touchedNode.name{
                if name == "restart"{
                    print("touched")
                }
            }
        
            
            /*ball.position = positionOfTouch
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.restitution = 0.8
            ball.physicsBody?.linearDamping = 0
            self.addChild(ball)*/
            
            touchStart(positionOfTouch)
            
            //Setting the powerbar
            powerBar.position = CGPoint(x: size.width - size.width/2, y: size.height - size.height/3)
            powerBar.size = CGSize(width: 700, height: 100)
            powerBar.zPosition = -1
            addChild(powerBar)
            
            //Setting the powerpin
            powerPin.position = CGPoint(x: size.width - size.width/2 - 350, y: size.height - size.height/3)
            powerPin.size = CGSize(width: 50, height: 150)
            powerPin.zPosition = 0
            addChild(powerPin)
            
            if replay == touchedNode{
                restartGame()
            }
            
        }
        
    }
    
    func restartGame(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
        let transition = SKTransition.fadeWithDuration(1.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.AspectFit
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force/maximumPossibleForce
            
            
            
            powerPin.position.x = (size.width - size.width/2 - 350) + normalizedForce * (self.size.width/2 - 350)
            weaponPower = force * 1000
            print(weaponPower)
        }
        
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
        
       /* if isTouching == true {
            var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("powerControl"), userInfo: nil, repeats: true)
            print(weaponPower)
        }*/
    
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        
        //This function controlls so you can only touch the screen oncx
        
        touchStopped(touchLocation)
    }
    
    func touchStopped(touchPoint: CGPoint){
        let angle = arrow.zRotation
        let startingVelocity = CGVectorMake((π/2-angle)*weaponPower, angle*weaponPower)
        arrow.removeFromParent()
        powerBar.removeFromParent()
        powerPin.removeFromParent()
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
         ball.physicsBody?.affectedByGravity = true
         ball.physicsBody?.restitution = 0.6
         ball.physicsBody?.linearDamping = 0.8
         ball.physicsBody?.angularDamping = 0.9
         ball.physicsBody?.velocity = startingVelocity
    }
    
    func powerControl () {
        weaponPower = weaponPower + 50
    }
}
