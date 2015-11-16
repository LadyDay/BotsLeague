//
//  GameScene.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var level: Levels = LevelOne(fileNamed: "LevelOne")!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        displayLevel(level)
    }
    
    func displayLevel(level: Levels){
        let viewLevel = SKView(frame: CGRectMake(75, 370, 620, 540))
        viewLevel.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(viewLevel as UIView)
        viewLevel.presentScene(level)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
        }
        */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
