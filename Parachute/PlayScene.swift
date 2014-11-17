//
//  PlayScene.swift
//  Parachuter
//
//  Created by Kai Fabian Tait on 22/10/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "playerSmall")
    let cloud = SKSpriteNode(imageNamed: "cloud")
    let cloud2 = SKSpriteNode(imageNamed: "cloud2")
    
    //determeine screenSize
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //let screenWidth = screenSize.width
   // let screenHeight = screenSize.height
    
    var origCloudPositionY = CGFloat(5)
    var cloudPositionX = CGFloat(5)
    var maxCloudY = CGFloat(0)
    var maxObjY = CGFloat(0)
    var maxObjX = CGFloat (0)
    var cloudSpeed = 5
    
    override func didMoveToView(view: SKView!) {
        println("We're at the new scene!")
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
        self.player.anchorPoint = CGPointMake(0.5, 0.5)
        self.player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + (CGRectGetMidY(self.frame)/2 ))
        
        self.addChild(self.player)
        self.addChild(self.cloud)

    }
    //Game functions
    //####################
    func setupGame() {
        //do setup
    }
    func gameOver() {
        //gameOver code
    }
    func newHighScore() {
        // high score code
    }
    func togglePause() {
        //pause/resume
    }
    func collision() {
        //collision code
    }
    func gameLoop() {
        //the function that calls everything else
    }
    
    //Player functions
    //####################
    func canMove() {
        //check move is valid
    }
    func movePlayer() {
        //move the player
    }
    func loseHealth() {
        //removes a life
    }
    func checkHealth() {
        // check player health
    }
    
    //Object functions
    //####################
    func setNewObjPosition(name: SKSpriteNode) -> CGFloat {
        //set the position
        var newObjPosition = CGFloat(5)
        return newObjPosition
    }
    
    func respawn(name: SKSpriteNode) {
        name.position.y = origCloudPositionY
    }
    func objectOffSceen(name: SKSpriteNode) {
        println( "name = \(_stdlib_getTypeName(name))")
        name.position.y = origCloudPositionY
        //self.cloud.position.y = origCloudPositionY
        self.maxObjY = screenSize.height
        println(self.cloud.position.y)
        //  println(screenSize.height)
    }
    
    func cloudOffScreen() {
        self.cloud.position.y = origCloudPositionY
        self.maxObjY = screenSize.height
       println(self.cloud.position.y)
      //  println(screenSize.height)
    }

    

    
    override func update(currentTime: NSTimeInterval) {
        
        if self.cloud.position.y >= maxCloudY {
            //self.cloud.position.y = self.origCloudPositionY
            objectOffSceen(cloud2)
        }
        //move the cloud
        cloud.position.y += CGFloat(self.cloudSpeed)
    }
}
