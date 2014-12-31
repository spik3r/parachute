//
//  HighScore.swift
//  Parachute
//
//  Created by Kai Fabian Tait on 25/11/2014.
//  Copyright (c) 2014 Titanitestudios. All rights reserved.
//

import foundation


// inherit from NSCoding to make instances serializable
class HighScore: NSObject, NSCoding {
    let score:Int;
    let dateOfScore:NSDate;
    
    init(score:Int, dateOfScore:NSDate) {
        self.score = score;
        self.dateOfScore = dateOfScore;
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObjectForKey("score")! as Int;
        self.dateOfScore = coder.decodeObjectForKey("dateOfScore")! as NSDate;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.dateOfScore, forKey: "dateOfScore")
    }
}
