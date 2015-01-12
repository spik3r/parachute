//
//  GameOverScene.swift
//  Parachute
//
//  Created by Kai Fabian Tait on 25/11/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import SpriteKit


class GameOverScene: SKScene {
    
    let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
    let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    
    let facebook = SKSpriteNode(imageNamed: "facebook")
    let twitter = SKSpriteNode(imageNamed: "twitter")
    let playButton = SKSpriteNode(imageNamed: "playButton")
    
    var score = 0
    var highscore = 0
    
    var userDefaults = NSUserDefaults.standardUserDefaults()

    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        //notification
        NSNotificationCenter.defaultCenter().postNotificationName("hideAds", object: nil)
        
        self.highscore = getHighscore()
        if score > highscore {
            //print(highscore)
            setHighScore(score)
            self.gameOverLabel.text = String("You Beat the HighScore!")
            self.highScoreLabel.text = String("New HighScore: ") + String(score)
            userDefaults.setValue(self.score, forKey: "highscore")
            userDefaults.synchronize()
        }
        else {
            self.gameOverLabel.text = String("You did not beat the HighScore of: ") + String(self.highscore)
            self.highScoreLabel.text = String("Your score: ") + String(self.score)
        }
        
        
        self.gameOverLabel.fontSize = 25
        self.highScoreLabel.fontSize = 25
        self.gameOverLabel.fontColor = SKColor.blackColor()
         self.highScoreLabel.fontColor = SKColor.blackColor()
        self.gameOverLabel.position = CGPoint(x: (size.width/2), y: (size.height/2))
        self.highScoreLabel.position = CGPoint(x: (size.width/2), y: (size.height/2 - size.height/5))
        self.addChild(gameOverLabel)
        self.addChild(highScoreLabel)
        
        self.twitter.position = CGPoint(x: (60), y: (size.height - 60))
        addChild(twitter)
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), (size.height - 60))
        self.addChild(playButton)
        self.facebook.position = CGPoint(x: (size.width - 60), y: (size.height - 60))
        self.addChild(facebook)
        
    }
    
    func getHighscore() -> Int {
        var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey("highscore") as? Int
        if returnValue == nil {
            returnValue = 0
        }
        return returnValue!
    }
    
    func setHighScore(newHighScore: Int) {
        NSUserDefaults.standardUserDefaults().setObject(newHighScore, forKey: "highscore")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.playButton {
                //println("Go to the game!")
                var scene = PlayScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
            if self.nodeAtPoint(location) == self.facebook {
                // post to facebook
                //println("fb pushed")
                NSNotificationCenter.defaultCenter().postNotificationName("facebook", object: nil)
            }
            if self.nodeAtPoint(location) == self.twitter {
                NSNotificationCenter.defaultCenter().postNotificationName("twitter", object: nil)
            }
        }
        
    }

}