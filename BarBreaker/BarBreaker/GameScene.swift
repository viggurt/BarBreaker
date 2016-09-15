//
//  GameScene.swift
//  BarBreaker
//
//  Created by Viktor on 26/08/16.
//  Copyright (c) 2016 viggurt. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory{
        static let Ball1: UInt32    = 0
        static let Ball2: UInt32    = 0b1
    }
    
    
    let background = SKSpriteNode(imageNamed: "background-football")
    //var ball = SKSpriteNode(imageNamed: "ball1")
    //var ball2 = SKSpriteNode(imageNamed: "ball1")
    let goal = SKSpriteNode(imageNamed: "goal-football")
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let powerBar = SKSpriteNode(imageNamed: "power_bar")
    let powerPin = SKSpriteNode(imageNamed: "power_pin")
    let replay = SKSpriteNode(imageNamed: "replay")
    var points: Int = 0
    var ballGone: Bool!
    var gameState: GameState?
    
    var weaponPower: CGFloat = 1500
    let π = CGFloat(M_PI)
    
    var ball = BallOne()
    let ball2 = BallTwo()
    
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
    
        ball.position = CGPoint(x: 100 , y: 0)
        ball.zPosition = 2
    
        addChild(ball)
        
        ball.physicsBody?.velocity.dx = 0.4
        ball.physicsBody?.velocity.dy = 0.4
        
        //Ball2
        
        ball2.position = CGPoint(x: size.width - 250, y: size.height - size.height + 450)
        ball2.zPosition = 2
        
        /*ball2.physicsBody?.categoryBitMask = physicsCategory.Ball2
        ball2.physicsBody?.collisionBitMask = physicsCategory.Ball1
        ball2.physicsBody?.contactTestBitMask = physicsCategory.Ball1
        ball2.name = "Ball2"
        ball2.physicsBody?.affectedByGravity = true
        ball2.physicsBody?.dynamic = false*/
        
        addChild(ball2)
        
        //Setting the position of the goal and adding it to the view
        goal.position = CGPoint(x: size.width - 150, y: size.height - size.height + 200)
        goal.size = CGSize(width: 300, height: 400)
        goal.physicsBody = SKPhysicsBody(rectangleOfSize: goal.size)
        goal.physicsBody?.affectedByGravity = false
        goal.physicsBody?.dynamic = false
        addChild(goal)
        
        physicsWorld.contactDelegate = self
        
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
        
        //Replay-button
        replay.position = CGPoint(x: size.width - size.width/size.width - 60, y: size.height - size.height/size.width - 60)
        replay.size = CGSize(width: 100, height: 100)
        replay.name = "restart"
        addChild(replay)
        
        //Tells if the ball we hit is gone
        ballGone = false
        
        if ballGone == false{
            
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
       let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Ball1 | PhysicsCategory.Ball2{
            ball2.physicsBody?.dynamic = true
            points += 1
            print("contact")
            print(points)
            ball2.removeFromParent()
            ballGone = true
        }
        
        
    }
    
    func restart(){
        self.removeAllChildren()
        self.removeAllActions()
        let gameScene:GameScene = GameScene(size: background.size)
        let transition = SKTransition.fadeWithDuration(1.0)
        self.view!.presentScene(gameScene, transition: transition)
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
            
            /*ball.position = positionOfTouch
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.restitution = 0.8
            ball.physicsBody?.linearDamping = 0
            self.addChild(ball)*/
            

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
            
                touchStart(positionOfTouch)
            
            
            if replay == touchedNode{
                restart()
            }
            
        }
        
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
        self.userInteractionEnabled = false
        
        if ball.physicsBody!.velocity.dx == 0.0 && ball.physicsBody!.velocity.dy == 0.0 {
            restart()
        }
        
        touchStopped(touchLocation)
    }
    
    func touchStopped(touchPoint: CGPoint){
        
        let angle = arrow.zRotation
        let startingVelocity = CGVectorMake((π/2-angle)*weaponPower, angle*weaponPower)
        arrow.removeFromParent()
        powerBar.removeFromParent()
        powerPin.removeFromParent()
        
        ball.physicsBody?.velocity = startingVelocity
        
    }
}
