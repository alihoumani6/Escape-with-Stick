//
//  Highscores.swift
//  Escape with Stick
//
//  Created by Ali H on 2015-04-01.
//  Copyright (c) 2015 Ali H. All rights reserved.
//

import Foundation
// inherit from NSCoding to make instances serializable
class HighScore: NSObject, NSCoding {
    let score:Int;
    let dateOfScore:NSDate;
    
    init(score:Int, dateOfScore:NSDate) {
        self.score = score;
        self.dateOfScore = dateOfScore;
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObjectForKey("score")! as! Int;
        self.dateOfScore = coder.decodeObjectForKey("dateOfScore")! as! NSDate;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(GameScene.self, forKey: "score")
        coder.encodeObject(self.dateOfScore, forKey: "dateOfScore")
    }
}