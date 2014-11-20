//
//  PlayScene.swift
//  Parachute
//
//  Created by Kai Fabian Tait on 10/11/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import SpriteKit


class PlayScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "playerSmall")
    let cloud = SKSpriteNode(imageNamed: "cloud")
    let cloud2 = SKSpriteNode(imageNamed: "cloud")
    let cloud3 = SKSpriteNode(imageNamed: "cloud")
    let cloud4 = SKSpriteNode(imageNamed: "cloud")
    
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
    var cloudSpeed = 5
    var playerSpeed = CGFloat (3)
    var livesLeft: Int = 0
    var gamePaused = false
    
    override func didMoveToView(view: SKView!) {
        println("We're at the new scene!")
        //do the setup
        setupGame()

    }
    //Game functions
    //####################
    func setupGame() {
        //do setup
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        self.livesLeft = 3
        self.playerSpeed = CGFloat (3)
        self.gamePaused = false
        
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
        //add to screen
        self.addChild(self.player)
        self.addChild(self.cloud)
        self.addChild(self.cloud2)
        self.addChild(self.cloud3)
        self.addChild(self.cloud4)
    }
    
    func gameOver() {
        //gameOver code
    }
    
    func newHighScore() {
        // high score code
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
    }
    func gameLoop() {
        //the function that calls everything else
    }
    
    //Player functions
    //####################
    func canMove() -> Bool{
        if player.position.x + player.size.width/2 > self.maxObjX || player.position.x - player.size.width/2 < 0{
            
            // can't move
            return false
        }else {
            //can move
            return true
        }
    }
    func movePlayer() {
        //move the player
        if canMove() {
            player.position.x += playerSpeed
        }else {
            playerSpeed *= -1
            player.position.x += playerSpeed
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
    
    func respawn(name: SKSpriteNode) {
        var newPosition = setNewObjPosition(name)
        name.position.x = newPosition
        name.position.y = cloudPositionY
    }
    func objectOffSceen(name: SKSpriteNode) {
        if name.position.y >= self.maxObjY{
            respawn(name)
        }
        if name.position.x > self.maxObjX || name.position.x < 0{
            // off screen x-axis
        }
        
        //println( "name = \(_stdlib_getTypeName(name))")
    }
    
    func cloudOffScreen() {
        self.cloud.position.y = origCloudPositionY
        self.maxObjY = screenSize.height
        println(self.cloud.position.y)
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            //if self.nodeAtPoint(location) == self.playButton {
                println("tapped the screen!")
                togglePause(self.gamePaused)

            //}
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {

        if !gamePaused {
            
            cloud.position.y += CGFloat(self.cloudSpeed)
            cloud2.position.y += CGFloat(self.cloudSpeed)
            cloud3.position.y += CGFloat(self.cloudSpeed)
            cloud4.position.y += CGFloat(self.cloudSpeed)
            
            objectOffSceen(cloud)
            objectOffSceen(cloud2)
            objectOffSceen(cloud3)
            objectOffSceen(cloud4)
            
            movePlayer()
        }

    }
}
