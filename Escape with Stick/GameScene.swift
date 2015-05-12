//
//  GameScene.swift
//  Escape with Stick
//
//  Created by Ali H on 2015-03-19.
//  Copyright (c) 2015 Ali H. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var score = 1
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    var hero = SKSpriteNode()
    var bg = SKSpriteNode()
    var labelHolder = SKSpriteNode()
    
    var aliensUpDown = SKSpriteNode()
    
    var moveYup = SKAction.moveToY(5, duration: 1)
    
    var moveYdown = SKAction.moveToY(-5, duration: 1)
    
    var bgMusic = SKAction.playSoundFileNamed("SuperBGM.mp3", waitForCompletion: true)
    
    var pointSound = SKAction.playSoundFileNamed("MarioCoin.mp3", waitForCompletion: true)
    
    
    let heroGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    let gapGroup:UInt32 = 0 << 3
    
    var gameOver = 0
    
    
    var movingObjects = SKNode() //will allow us to control/stop all moving objects
    
    override func didMoveToView(view: SKView) {
        
        //contact delegate
        self.physicsWorld.contactDelegate = self
        
        //gravity
        self.physicsWorld.gravity = CGVectorMake(0, -7)
        
        self.addChild(movingObjects)
        
        makeBackground()
        self.addChild(labelHolder)
        
        
        
        
        
        //hero
        var heroTexture = SKTexture(imageNamed: "img/flyingstick.png")
        var heroTexture2 = SKTexture(imageNamed: "img/flyingstick2.png")
        
        
        
        
        //sets up animation
        
        var animation = SKAction.animateWithTextures([heroTexture, heroTexture2], timePerFrame: 0.1)
        var makeherofly = SKAction.repeatActionForever(animation)
        
        
        hero = SKSpriteNode(texture: heroTexture)
        
        //puts hero in middle of frame
        
        hero.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        //starts the fly
        
        hero.runAction(makeherofly)
        
        
        //physics
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.height/2)
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.allowsRotation = false
        
        
        hero.physicsBody?.categoryBitMask = heroGroup
        
        //collision, detecting between hero & pipe/ground
        hero.physicsBody?.collisionBitMask = objectGroup
        hero.physicsBody?.contactTestBitMask = objectGroup
        hero.physicsBody?.collisionBitMask = gapGroup
        
        //layers it about the background and Aliens
        
        hero.zPosition = 10
        
        //adds new object on the screen, hero
        self.addChild(hero)
        
        
        
        
        //ground
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width,1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)
        
        //SCORE LABEL
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        //timer
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makeAliens"), userInfo: nil, repeats: true)
        
        //score
        
        
    }
    
    //music
    
    
    func playSound(bgMusic : SKAction)
    {
        
        
        runAction(bgMusic)
        
        
    }
    
    func gotPoint(pointSound : SKAction)
    {
        
        
        runAction(pointSound)
        
        
    }
    
    
    func makeBackground(){
        //background
        
        var bgTexture = SKTexture(imageNamed: "menuBG")
        
        
        //background movement
        
        var moveBG = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replaceBG = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var moveBGForever = SKAction.repeatActionForever(SKAction.sequence([moveBG, replaceBG]))
        
        for var i:CGFloat = 0; i < 3; i++
        {
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveBGForever)
            
            movingObjects.addChild(bg)
        }
        
    }
    
    func makeAliens() {
        
        if (gameOver == 0){
            //alien animations
            var animateMoveAliensUp = SKAction.sequence([moveYup])
            var animateMoveAliensDown = SKAction.sequence([moveYdown])
            var moveAliensUp = SKAction.repeatActionForever(animateMoveAliensUp)
            var moveAliensDown = SKAction.repeatActionForever(animateMoveAliensDown)
            
            
            // size of 4 heroes to allow us to pass through
            let gapHeight = hero.size.height * 4
            
            //movement of Aliens, divide by 2 so its half of the screen, random
            //number between 0 and half of the screen size
            var movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
            
            //amount Aliens is gonna move, moves up or down by a quarter of the screen
            var AliensOffset = CGFloat(movementAmount) - self.frame.size.height / 4
            
            
            //Aliens
            
            //movement
            //aliens start slightly right and end up on self side of the screen
            //they're moving double the width of the screen
            var moveAliens = SKAction.moveByX(-self.frame.size.width * 2, y:0, duration: NSTimeInterval(self.frame.width / 100))
            
            //removes Aliens when they become off screen
            var removeAliens = SKAction.removeFromParent()
            
            var moveAndRemoveAliens = SKAction.sequence([moveAliens, removeAliens])
            
            
            
            
            //images, positioning of Aliens AND MUSIC
            var AliensTexture = SKTexture(imageNamed: "img/alienstick1.png")
            var alien1 = SKSpriteNode(texture: AliensTexture)
            
            //sets the position so the aliens appear half a screen away
            alien1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + alien1.size.height / 2 + gapHeight / 2 + AliensOffset)
            alien1.runAction(moveAndRemoveAliens)
            
            //Aliens physics
            alien1.physicsBody = SKPhysicsBody(rectangleOfSize: alien1.size)
            alien1.physicsBody?.dynamic = false
            alien1.physicsBody?.categoryBitMask = objectGroup
            // alien1.runAction(moveAliensUp)
            
            //add Aliens
            movingObjects.addChild(alien1)
            
            //images and positioning
            var alien2Texture = SKTexture(imageNamed: "img/alienstick1.png")
            var alien2 = SKSpriteNode(texture: alien2Texture)
            //sets the position so the aliens appear half a screen away
            alien2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - alien2.size.height / 2 - gapHeight / 2 + AliensOffset)
            alien2.runAction(moveAndRemoveAliens)
            
            //Aliens physics
            alien2.physicsBody = SKPhysicsBody(rectangleOfSize: alien2.size)
            alien2.physicsBody?.dynamic = false
            alien2.physicsBody?.categoryBitMask = objectGroup
            //alien2.runAction(moveAliensUpDown)
            
            //add Aliens
            movingObjects.addChild(alien2)
            
            //Gap
            
            //getting gap position so when we fly through we get the score
            var gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + AliensOffset)
            
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(alien1.size.width, gapHeight))
            
            gap.runAction(moveAndRemoveAliens)
            gap.physicsBody?.dynamic = false
            
            //allows hero to fly through gap
            gap.physicsBody?.collisionBitMask = gapGroup
            
            gap.physicsBody?.categoryBitMask = gapGroup
            
            gap.physicsBody?.contactTestBitMask = heroGroup
            
            movingObjects.addChild(gap)
            
        }
        
    }
    


    func didBeginContact(contact: SKPhysicsContact) {
        // method for the contact of the hero and ground or hero and Aliens
        
        //To save highest score
        
        NSUserDefaults.standardUserDefaults().setObject(score, forKey:"Score")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //To get the saved score
        var savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("Score") as! Int
        
        
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {
            score++
            scoreLabel.text = "\(score)"
            gotPoint(pointSound)
            println(savedScore)
            
            
        }
        else {
            if gameOver == 0 {
                
                gameOver = 1
                movingObjects.speed = 0
                
                //Game Over LABEL
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.color = UIColor.blackColor()
                gameOverLabel.text = "Game over, tap to play again!"
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelHolder.addChild(gameOverLabel)
            }
        }
        
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        
        
        if (gameOver == 0){
            
            hero.physicsBody?.velocity = CGVectorMake(0, 0)
            hero.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }
            
        else {
            
            
            // when player clicks restart
            score = 0
            
            scoreLabel.text = "0"
            
            movingObjects.removeAllChildren()
            
            makeBackground()
            
            // playSound(bgMusic)
            
            hero.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            
            //makes velocity 0 so we can get hero
            hero.physicsBody?.velocity = CGVectorMake(0, 0)
            
            
            labelHolder.removeAllChildren()
            
            gameOver = 0
            
            movingObjects.speed = 1
            
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
