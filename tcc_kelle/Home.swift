//
//  Home.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class Home: SKScene {
    //buttons
    var size_buttonStart: CGSize = CGSize(width: 50, height: 50)
    var size_buttonFb: CGSize = CGSize(width: 50, height: 50)
    
    //image
    var size_logo: CGSize = CGSize(width: 200, height: 100)
    
    var logo = MyButtonNode(imageNamed: "logo")
    var buttonStart = MyButtonNode(imageNamed: "start")
    var buttonFb = MyButtonNode(imageNamed: "bt_facebook")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.logo.size = self.size_logo
        self.logo.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+self.size_logo.height)
        
        self.buttonStart.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-self.size_buttonStart.height)
        self.buttonStart.size = self.size_buttonStart
        
        self.buttonFb.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-self.size_buttonStart.height-self.size_buttonFb.height)
        self.buttonFb.size = self.size_buttonFb
        
        self.addChild(self.logo)
        self.addChild(self.buttonStart)
        self.addChild(self.buttonFb)
    }
/*
        override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self.skView?.scene)
            // Check if the location of the touch is within the button's bounds
            let no = self.skView?.scene?.nodeAtPoint(self.location)
            no?.touchesEnded(touches, withEvent: event)
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self.scene)
    
            // Check if the location of the touch is within the button's bounds
            let no = self.scene?.nodeAtPoint(location)
            if(no?.isEqualToNode(self.buttonStart)){
                
            }
            no?.touchesEnded(touches, withEvent: event)
        }
    
    }
*/
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    

}

