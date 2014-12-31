//
//  PlayScene.swift
//  Parachute
//
//  Created by Kai Fabian Tait on 10/11/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import SpriteKit
import CoreMotion



class PlayScene: SKScene {
    
    //coremotion
    let manager: CMMotionManager = CMMotionManager()
    let label = SKLabelNode(fontNamed: "Chalkduster")
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    //player
    var player = SKSpriteNode(imageNamed: "playerSmall")
    var playerY = CGFloat(0)

    var leftSpeed = CGFloat(-3)
    var rightSpeed = CGFloat(3)
    var direction:String = "none"
    
    //clouds
    let cloud = SKSpriteNode(imageNamed: "cloud")
    let cloud2 = SKSpriteNode(imageNamed: "cloud")
    let cloud3 = SKSpriteNode(imageNamed: "cloud")
    let cloud4 = SKSpriteNode(imageNamed: "cloud")
    //enemies
    let planeLeft = SKSpriteNode(imageNamed: "plane")
    let planeRight = SKSpriteNode(imageNamed: "planeRight")
    let jet = SKSpriteNode(imageNamed: "newPlaneRightSmall")
    
    //determeine screenSize
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //let screenWidth = screenSize.width
    // let screenHeight = screenSize.height
    
    var origCloudPositionY = CGFloat(5)
    var cloudPositionX = CGFloat(35)
    var cloudPositionY = CGFloat(0)
    //var cloud2PositionX = CGFloat(350)
    //var cloud2PositionY = CGFloat(200)
    var maxCloudY = CGFloat(0)
    var maxObjY = CGFloat(0)
    var maxObjX = CGFloat (0)
    var cloudSpeed = 3
    var playerSpeed = CGFloat (3)
    var playerSpeedY = CGFloat(0)
    var livesLeft: Int = 3
    var gamePaused = false
    var leftPlaneSpeed = CGFloat (-3)
    var rightPlaneSpeed = CGFloat (3)
    var planesPassed = 0
    var score = 0
    
    let motionManager = CMMotionManager()

    
    override func didMoveToView(view: SKView!) {
        println("We're at the new scene!")
        //do the setup
        setupGame()
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates()

    }
    //Game functions
    //####################
    func setupGame() {
        //do setup
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        self.livesLeft = 3
        self.playerSpeed = CGFloat (3)
        self.playerY = CGRectGetMidY(self.frame) + (CGRectGetMidY(self.frame)/2 )
        self.gamePaused = false
        self.leftPlaneSpeed = CGFloat (-3)
        self.rightPlaneSpeed = CGFloat (3)
        //player
        self.player = SKSpriteNode(imageNamed: "playerSmall")
        self.score = 0
        self.direction = "none"
        
        self.leftSpeed = CGFloat (-3)
        self.rightSpeed = CGFloat (3)
        
        self.scoreLabel.text = "lives: " + String(self.livesLeft)
        self.scoreLabel.fontSize = 40
        self.scoreLabel.fontColor = SKColor.blackColor()
        self.scoreLabel.position = CGPoint(x: (size.width/4), y: (size.height - size.height/8))
        self.addChild(scoreLabel)
        
        self.label.text = "score: " + String(self.score)
        self.label.fontSize = 40
        self.label.fontColor = SKColor.blackColor()
        self.label.position = CGPoint(x: (size.width - size.width/4), y: (size.height - size.height/8))
        self.addChild(label)
        
        //objects
        self.maxObjY = screenSize.height
        self.maxObjX = screenSize.width
        self.cloudPositionX = CGFloat(35)
        self.cloudPositionY = CGFloat(0)
        self.player.anchorPoint = CGPointMake(0.5, 0.5)
        self.player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + (CGRectGetMidY(self.frame)/2 ))
        
        self.cloud.position = CGPointMake(setNewObjPosition(cloud), cloudPositionY)
        self.cloud2.position = CGPointMake(setNewObjPosition(cloud2), (screenSize.height/2 + screenSize.height/6))
        self.cloud3.position = CGPointMake(setNewObjPosition(cloud3), screenSize.height/2)
        self.cloud4.position = CGPointMake(setNewObjPosition(cloud3), screenSize.height/5)
        //enemies
        self.planeLeft.position = CGPointMake(screenSize.width, (screenSize.height/2))
        self.planeRight.position = CGPointMake(CGFloat(0), (screenSize.height/10))
        self.jet.position = CGPointMake(CGFloat(0), CGFloat(0))
        self.planesPassed = 0
        
        //add to screen
        self.addChild(self.player)
        self.addChild(self.cloud)
        self.addChild(self.cloud2)
        self.addChild(self.cloud3)
        self.addChild(self.cloud4)
        self.addChild(self.planeLeft)
        self.addChild(self.planeRight)
        //self.addChild(self.jet)
    }
    
    
    
    func gameOver() {
        //gameOver code
        
        var scene = GameOverScene(size: self.size)
        let skView = self.view as SKView!
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        scene.score = self.score
        skView.presentScene(scene)
    }
    
    func newHighScore() {
        // high score code
    }
    
    func incrementScore() {
        self.score += 1
        self.label.text = "score: " + String(self.score)
    }
    
    func togglePause(isPaused: Bool) {
        //pause/resume
        if isPaused {
            self.gamePaused = false
            println("unpaused")
        }
        else {
            self.gamePaused = true
            println("paused")
        }
            
        
    }
    func collision() {
        //collision code
        if self.player.intersectsNode(self.planeLeft) {
            //collision
            //println("collision pleft")
            //planeLeft.removeFromParent()
            if self.livesLeft - 1 >= 0 {
                self.livesLeft -= 1
                self.scoreLabel.text = "lives: " + String(self.livesLeft)
                self.respawn(planeRight, direction: "left")


            }
            else {
                //game over
                gameOver()
            }
            
            self.respawn(planeLeft, direction: "left")
        } else if self.player.intersectsNode(self.planeRight) {
            //println("collision pright")
            planeRight.removeFromParent()
            
            if self.livesLeft - 1 >= 0 {
                self.livesLeft -= 1
                self.scoreLabel.text = "lives: " + String(self.livesLeft)
                self.respawn(planeRight, direction: "right")
            }
            else {
                //game over
                gameOver()
            }
        }
    }
    func gameLoop() {
        //the function that calls everything else
    }
    
    //Player functions
    //####################
    func canMove() -> Bool{
        if gamePaused {
            return false
        }
        if player.position.x + player.size.width/2 > self.maxObjX {
            
            // can't move
            player.position.x -= 1
            return false
        }
        if player.position.x - player.size.width/2 < 0 {
            //can't move
            player.position.x += 1
            return false
        }
//        else {
//            //can move
//            return true
//        }
        if player.position.y + player.size.height/2 > self.maxObjY {
            
            // can't move
            player.position.y -= 1
            return false
        }
        if player.position.y - player.size.height/2 < 0 {
            //can't move
            player.position.y += 1
            return false
        }
        else {
            //can move
            return true
        }
    }
    
    func movePlayer(direction: String) {
        //move the player
        if canMove() {
            if direction == "left" {
                self.player.position.x += self.leftSpeed
                updatePlayerImage()
            }
            if direction == "right" {
                self.player.position.x += self.rightSpeed
                updatePlayerImage()
            }
            if direction == "up" {
                self.player.position.y += self.leftSpeed/2
                //updatePlayerImage()
            }
            if direction == "down" {
                self.player.position.y += self.rightSpeed/2
                //updatePlayerImage()
            }
        }
    }
    
    func getPlayerDirection() {
        println("get direction")

        if let attitude = motionManager.deviceMotion?.attitude? {
            println(attitude)
            let y = CGFloat(-attitude.pitch * 2 / M_PI)
            let x = CGFloat(-attitude.roll * 2 / M_PI)
            print("X: ")
            println(x)
            print("Y: ")
            println(y)
            if y > 0 {
                //right
                setSpeedRight()
                updatePlayerImage()
            }
            if y < 0 {
                //right
                setSpeedLeft()
                updatePlayerImage()
            }
            if x > 0 {
                //down
                setSpeeddown()
                //updatePlayerImage()
            }
            if x < 0 {
                //up
                setSpeedUp()
                //updatePlayerImage()
            }
        }
        
//        if manager.accelerometerAvailable {
//            
//            manager.accelerometerUpdateInterval = 0.01
//            
//            manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
//                [weak self] (data: CMAccelerometerData!, error: NSError!) in
//                
//                var rotation = atan2(data.acceleration.x, data.acceleration.y) - M_PI
//                //println(data.acceleration.y)
//                //println("Y: ")
//                
//                if (self?.canMove() != nil ) {
//                    if data.acceleration.y < 0 {
//                        //left
//                        //println("left")
//                        //self?.player.position.x += CGFloat(-3)
//                        self?.setSpeedLeft()
//                        self?.updatePlayerImage()
//                    
//                    }
//                }
//                if data.acceleration.y > 0 {
//                    //right
//                    //println("right")
//                    //self?.player.position.x += CGFloat(3)
//                    self?.setSpeedRight()
//                    self?.updatePlayerImage()
//                }
//            }
//        }

    }
    
    func setSpeedLeft(){
        self.playerSpeed = CGFloat(-3)
        movePlayer("left")
    }
    
    func setSpeedRight(){
        self.playerSpeed = CGFloat(3)
        movePlayer("right")
    }
    func setSpeedUp(){
        self.playerSpeedY = CGFloat(-3)
        movePlayer("up")
    }
    
    func setSpeeddown(){
        self.playerSpeedY = CGFloat(3)
        movePlayer("down")
    }
    
    func updatePlayerImage() {
        if self.gamePaused == false {
            if self.playerSpeed > -1 {
                //set player image to right
                
                player.removeFromParent()
                var x = player.position.x
                var y = player.position.y
                self.player = SKSpriteNode(imageNamed: "playerSmallRight")
                self.player.position = CGPointMake(x, y )
                self.addChild(self.player)
            }
            else {
                //set player image to left
                player.removeFromParent()
                var x = player.position.x
                var y = player.position.y
                self.player = SKSpriteNode(imageNamed: "playerSmallLeft")
                self.player.position = CGPointMake(x, y )
                self.addChild(self.player)
            }
            
        }

    }
    
    
    func loseHealth() {
        //removes a life
    }
    func checkHealth() {
        // check player health
    }
    
    //Object functions
    //####################
    func setNewObjPosition(name: SKSpriteNode) -> CGFloat{
        //set the position
       var maxX = UInt32(maxObjX)
        var newObjPositionInt = arc4random_uniform(maxX)
        var newObjPosition = CGFloat(newObjPositionInt)
        return newObjPosition
    }
    func setNewObjPositionY(name: SKSpriteNode) -> CGFloat{
        //set the position
        var maxY = UInt32(maxObjY)
        var newObjPositionInt = arc4random_uniform(maxY)
        var newObjPositionY = CGFloat(newObjPositionInt)
        return newObjPositionY
    }
    
    
    func respawn(name: SKSpriteNode) {
        var newPosition = setNewObjPosition(name)
        name.position.x = newPosition
        name.position.y = cloudPositionY
    }
    func respawn(name: SKSpriteNode, direction: String) {
        if direction == "left" {
            name.position.x = self.maxObjX
        }
        else {
            name.position.x = CGFloat(0)
        }
        var newPosition = setNewObjPositionY(name)
        name.position.y = newPosition
    }
    
    func objectOffSceen(name: SKSpriteNode) {
        if name.position.y >= self.maxObjY{
            respawn(name)
        }
        if name.position.x > self.maxObjX {
            // off screen x-axis
            respawn(name, direction: "right")
            self.planesPassed += 1
            self.incrementScore()
        }
        if name.position.x < 0 {
            respawn(name, direction: "left")
            self.planesPassed += 1
            self.incrementScore()
        }
        
        //println( "name = \(_stdlib_getTypeName(name))")
    }
    
    func cloudOffScreen() {
        self.cloud.position.y = origCloudPositionY
        self.maxObjY = screenSize.height
        println(self.cloud.position.y)
    }
    
    //Enemy functions
    //####################
    func movePlaneLeft(name: SKSpriteNode) {
        var nameStr = name.name
        if nameStr != nil {
           println(nameStr)
        }
        name.position.x += self.leftPlaneSpeed
    }
    
    func movePlane(name: SKSpriteNode, direction: String) {
        if direction == "left" {
            //println(direction)
            name.position.x += self.leftPlaneSpeed
        }
        else{
            name.position.x += self.rightPlaneSpeed
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            //if self.nodeAtPoint(location) == self.playButton {
                println("tapped the screen!")
                togglePause(self.gamePaused)
                //movePlayerDown()
            //}
        }
    }
    
     override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            //movePlayerUp()
        }
        
    }
    func movePlayerDown() {
        
        self.player.position.y -= player.size.height
        player.removeFromParent()
        var x = player.position.x
        var y = player.position.y
        self.player = SKSpriteNode(imageNamed: "playerSmall")
        self.player.position = CGPointMake(x, y )
        self.addChild(self.player)
    }
    
    func movePlayerUp() {
        self.player.position.y = playerY
        player.removeFromParent()
        var x = player.position.x
        var y = player.position.y
        self.player = SKSpriteNode(imageNamed: "playerSmall")
        self.player.position = CGPointMake(x, y )
        self.addChild(self.player)
    }
    
    override func update(currentTime: NSTimeInterval) {

        if !gamePaused {
            
            cloud.position.y += CGFloat(self.cloudSpeed)
            cloud2.position.y += CGFloat(self.cloudSpeed)
            cloud3.position.y += CGFloat(self.cloudSpeed)
            cloud4.position.y += CGFloat(self.cloudSpeed)
            planeLeft.position.y += CGFloat(self.cloudSpeed/2)
            planeRight.position.y -= CGFloat(self.cloudSpeed/2)
            //jet.position.y += CGFloat(self.cloudSpeed)
            
            objectOffSceen(cloud)
            objectOffSceen(cloud2)
            objectOffSceen(cloud3)
            objectOffSceen(cloud4)
            objectOffSceen(planeLeft)
            objectOffSceen(planeRight)
            //if self.score % 5 == 0 {
                //planesPassed = 0
              //  objectOffSceen(self.jet)
            //}
            
            
            getPlayerDirection()
            movePlane((self.planeLeft), direction: "left")
            movePlane(self.planeRight, direction: "right")
            //movePlane(self.jet, direction: "right")
            
            collision()
        }

    }
    
}
