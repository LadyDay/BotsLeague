//
//  HierarquiaView.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/8/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class HierarquiaView: SceneInterface {
    
    var gameScene: GameScene!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame")
        self.boolMusic = dictionary!["boolMusic"] as! Bool
        self.boolEfects = dictionary!["boolEfects"] as! Bool
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            let body = self.nodeAtPoint(location) as? SKSpriteNode
            
            if let name: String = body!.name {
                switch name {
                    
                case "hierarquiaNode":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    gameScene.userInteractionEnabled = true
                    gameScene.boolHierarquia = false
                    self.view!.removeFromSuperview()
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
