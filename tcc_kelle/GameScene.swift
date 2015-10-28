//
//  GameScene.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameMatrix: Array = Array(count:6, repeatedValue:Array(count:7, repeatedValue:Int()))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view?.addGestureRecognizer(swipeUp)
        */
        updatingScenario()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
        }
        */
    }
    
    func updatingScenario(){
        for(var i = 0; i<7; i++){
            for(var j = 0; j<6; j++){
                let num = arc4random_uniform(6)
                gameMatrix[j][i] = Int(num)
                let lot = self.childNodeWithName("lot\(j)\(i)") as! SKSpriteNode
                lot.texture = SKTexture(imageNamed: "peca\(gameMatrix[j][i])")
            }
        }
    }
    
    func swipeDown(sender: UISwipeGestureRecognizer){
        /* Function to display the inventory */
        let position = sender.locationInView(self.view)
        let node = self.nodeAtPoint(position)
        
        //let name: String = node.name!
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
