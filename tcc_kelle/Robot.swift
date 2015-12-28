//
//  Robot.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 11/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class Robot: SKNode {
    var antenna: SKSpriteNode
    var head: SKSpriteNode
    var eyes: SKSpriteNode
    var rightArm: SKSpriteNode
    var leftArm: SKSpriteNode
    var legs: SKSpriteNode
    var body: SKSpriteNode

    required init?(coder aDecoder: NSCoder) {
        self.antenna = SKSpriteNode(imageNamed: "antenna-00")
        self.head = SKSpriteNode(imageNamed: "head-00")
        self.eyes = SKSpriteNode(imageNamed: "eyes-00")
        self.rightArm = SKSpriteNode(imageNamed: "rightArm-00")
        self.leftArm = SKSpriteNode(imageNamed: "leftArm-00")
        self.legs = SKSpriteNode(imageNamed: "legs-00")
        self.body = SKSpriteNode(imageNamed: "body-00")
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        self.antenna = SKSpriteNode(imageNamed: "antenna-00")
        self.head = SKSpriteNode(imageNamed: "head-00")
        self.eyes = SKSpriteNode(imageNamed: "eyes-00")
        self.rightArm = SKSpriteNode(imageNamed: "rightArm-00")
        self.leftArm = SKSpriteNode(imageNamed: "leftArm-00")
        self.legs = SKSpriteNode(imageNamed: "legs-00")
        self.body = SKSpriteNode(imageNamed: "body-00")
        super.init()
    }
    
    func loadRobotFromFile(){
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("Robot") {
            self.antenna.texture = SKTexture(imageNamed: dictionary["antenna"] as! String)
            self.head.texture = SKTexture(imageNamed: dictionary["head"] as! String)
            self.eyes.texture = SKTexture(imageNamed: dictionary["eyes"] as! String)
            self.rightArm.texture = SKTexture(imageNamed: dictionary["rightArm"] as! String)
            self.leftArm.texture = SKTexture(imageNamed: dictionary["leftArm"] as! String)
            self.legs.texture = SKTexture(imageNamed: dictionary["legs"] as! String)
            self.body.texture = SKTexture(imageNamed: dictionary["body"] as! String)
        }
    }
    
    func saveRobotFromFile(){
        
    }
    
}
