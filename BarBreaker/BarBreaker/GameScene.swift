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
    let goal = SKSpriteNode(imageNamed: "goal-football")
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let powerBar = SKSpriteNode(imageNamed: "power_bar")
    let powerPin = SKSpriteNode(imageNamed: "power_pin")
    let replay = SKSpriteNode(imageNamed: "replay")
    var scoreLbl: SKLabelNode!
    var ballGone: Bool!
    var gameState: GameState?
    var ballShot: Bool = false
    var playableRect: CGRect? = nil
    var currentPoints: Int
    
    var weaponPower: CGFloat = 1500
    let π = CGFloat(M_PI)
    
    var ball = BallOne()
    let ball2 = BallTwo()
    
    init(size: CGSize, point: Int) {
        currentPoints = point
        
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        
        //Adding the background to the view and setting it to be all the way to the back
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = self.frame.size
        background.zPosition = -2
        addChild(background)
        
        //This checks the background size and prints it in console
        let mySize = background.size
        print("Size: \(mySize)")
        
        //Ball1
    
        ball.position = CGPoint(x: 100 , y: 0)
        ball.zPosition = 2
        addChild(ball)
        ball.physicsBody!.velocity.dx = 1
        ball.physicsBody!.velocity.dy = 1
        
        //Ball2
        
        ball2.position = CGPoint(x: size.width - 250, y: size.height - size.height + 450)
        ball2.zPosition = 2
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
        /*replay.position = CGPoint(x: size.width - size.width/size.width - 60, y: size.height - size.height/size.width - 60)
        replay.size = CGSize(width: 100, height: 100)
        replay.name = "restart"
        addChild(replay)*/
        
        //Score Label
        scoreLbl = SKLabelNode(fontNamed: "Chalkduster")
        scoreLbl!.fontSize = 340
        scoreLbl!.position = CGPoint(x: self.frame.width / 2, y: scene!.frame.height / 2 + 300)
        scoreLbl!.fontColor = UIColor.blackColor()
        scoreLbl!.text = "\(currentPoints)"
        addChild(scoreLbl!)
        
        self.physicsBody!.restitution = 0.0
        
        //Rect
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        //Tells if the ball we hit is gone
        ballGone = false
        
        if ballGone == false{
            
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
       let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Ball1 | PhysicsCategory.Ball2{
            ball2.physicsBody?.dynamic = true
            currentPoints += 1
            ball2.removeFromParent()
            ballGone = true
            scoreLbl!.text = "\(currentPoints)"
        }
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        print(currentPoints)
        if ball.physicsBody!.velocity.dx > 200 || ball.physicsBody!.velocity.dy > 200 {
            ballShot = true
        }
        
        if ballGone == false {
            if ballShot == true {
                if ball.physicsBody!.velocity.dx <= 40 && ball.physicsBody!.velocity.dx >= -40 && ball.physicsBody!.velocity.dy <= 40 && ball.physicsBody!.velocity.dy >= -40 {
                    ball.physicsBody!.velocity.dx = 0.0
                    ball.physicsBody!.velocity.dy = 0.0
                
                        if ball.physicsBody!.velocity.dx == 0.0 && ball.physicsBody!.velocity.dy == 0.0 {
                            restart()
                        }
                }
            
            }
        }
        if ballGone == true{
            restart()
        }
    }
    
    
    func restart(){
        ball.position = CGPoint(x: 100 , y: 0)
        ball2.removeFromParent()
        let gameScene:GameScene = GameScene(size: background.size, point: currentPoints)
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let positionOfTouch = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionOfTouch)
            
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
    
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        
        //This function controlls so you can only touch the screen oncx
        self.userInteractionEnabled = false
        
        
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
    
    
    func endGame(won: Bool) {
        ball.physicsBody?.dynamic = false
        points+1
        
        if won {
            let moveToGym = SKAction.moveTo(ball2.position, duration: 0.3)
            let hideMain = SKAction.runBlock({self.ball.hidden = true})
            let endMessage = SKAction.runBlock({self.endMessage(won)})
            
            ball.runAction(SKAction.sequence([moveToGym,hideMain, endMessage]))
        } else {
            endMessage(won)
        }
        
    }
    
    func endMessage(won: Bool) {
        let background = SKSpriteNode(imageNamed: "infobox")
        background.size = CGSize(width: 3*playableRect!.width/4, height: 3*playableRect!.height/4)
        background.zPosition = 99
        
        let endLabel1 = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        let endLabel2 = SKLabelNode()
        
        endLabel1.fontSize = 150
        endLabel2.fontSize = 100
        
        endLabel1.position = CGPoint(x: 0, y: 200)
        endLabel2.position = CGPoint(x: 0, y: -400)
        endLabel1.zPosition = 100
        endLabel2.zPosition = 100
        
        let changeState: SKAction
        
        if won {
            scoreLbl.text = "\(points)"
            points+=1
            background.position.y = CGRectGetMidY(playableRect!)-playableRect!.height-100
            background.position.x = ball2.position.x
            
            changeState = SKAction.runBlock({ self.gameState = GameState.GameWon})
                    } else {
            endLabel1.text = "You lost!"
            endLabel2.text = "Touch anywhere to try again"
            background.position.x = ball.position.x
            background.position.y = CGRectGetMidY(playableRect!)-playableRect!.height-100
            
            changeState = SKAction.runBlock({self.gameState = GameState.GameLost})
            
            background.addChild(endLabel1)
            background.addChild(endLabel2)
        }
        
        addChild(background)
        
        let moveToMid = SKAction.moveBy(CGVectorMake(0, playableRect!.height), duration: 2)

        
        background.runAction(SKAction.sequence([moveToMid, SKAction.waitForDuration(1), changeState]))
    }
    
    func getDocumentsDirectory() -> URL{
        
    
    }
    
    
}
