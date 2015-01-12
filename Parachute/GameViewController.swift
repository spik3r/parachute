//
//  GameViewController.swift
//  Parachute
//
//  Created by Kai Fabian Tait on 10/11/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import Social


var adBannerView: ADBannerView!


extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    func loadAds() {
        
        adBannerView = ADBannerView(frame: CGRectZero)
        
        adBannerView.delegate = self
        adBannerView.hidden = true
        adBannerView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        view.addSubview(adBannerView)
    }
    
    func hideAds() {
            adBannerView.hidden = true
    }
    func showAds() {
        adBannerView.hidden = false
    }
    func screenShotMethod() {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        self.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        var image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        UIGraphicsEndImageContext();
        
        //self.imgView.image = image;
    }
    
    func showTweetSheet() {
        //println("going to twitter")
        //screenShotMethod()
        let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let highScore = getHighscore()
        
        tweetSheet.setInitialText("Check out my Highscore in parachute: \(highScore)") //The default text in the tweet
        tweetSheet.addImage(UIImage(named: "socialMedia.png")) //Add an image if you like?
        tweetSheet.addURL(NSURL(string: "http://www.titanitestudios.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(tweetSheet, animated: false, completion: {
            //Optional completion statement
        })
    }
    func getHighscore() -> Int {
        var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey("highscore") as? Int
        if returnValue == nil {
            returnValue = 0
        }
        return returnValue!
    }
    
    func showFaceBook() {
        //println("going to fb")
        //screenShotMethod()
        let facebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let highScore = getHighscore()
        
        facebook.setInitialText("Check out my Highscore in parachute: \(highScore)") //The default text in the tweet
        facebook.addImage(UIImage(named: "socialMedia.png")) //Add an image if you like?
        facebook.addURL(NSURL(string: "http://www.titanitestudios.com")) //A url which takes you into safari if tapped on
        
        self.presentViewController(facebook, animated: false, completion: {
            //Optional completion statement
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideAds", name: "hideAds", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAds", name: "showAds", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFaceBook", name: "facebook", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTweetSheet", name: "twitter", object: nil)
        


        

        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            //iAd
            loadAds()

        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //iAd
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
        
        //println("Ad about to load")
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
       // adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - view.bounds.size.height + adBannerView.frame.size.height / 2)
        adBannerView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height - adBannerView.frame.size.height / 2)
        adBannerView.hidden = false
        //println("Displaying the Ad")
        
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
        
        //println("Close the Ad")
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        //pause game here
        
        
        //println("Leave the application to the Ad")
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        //move off bounds when add didnt load
        
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height + view.bounds.size.height)
        
        //println("Ad is not available")
        
    }
    

}
