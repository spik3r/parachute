//
//  GameScene.swift
//  Parachute
//
//  Created by Kai Fabian Tait on 10/11/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "playButton")
    let welcomeLabel = SKLabelNode(fontNamed: "Chalkduster")
    override func didMoveToView(view: SKView) {
        
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.playButton)
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        self.welcomeLabel.text = String("Press the play button to begin")
        self.welcomeLabel.fontSize = 30
        self.welcomeLabel.fontColor = SKColor.blackColor()
        self.welcomeLabel.position = CGPoint(x: (size.width/2 ), y: (size.height/2 + size.height/4))
        self.addChild(welcomeLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                println("Go to the game!")
                var scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
