//
//  MenuView.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 02/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class MenuView: SKScene {
    
    var gameScene: SKScene!

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            print("\(location)")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    
    
}
