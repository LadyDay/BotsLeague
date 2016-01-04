//
//  PauseView.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/4/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class PauseView: SKScene {
    
    var gameScene: GameScene!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
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
                    
                case "resume":
                    print("buttonMenu Touched")
                    gameScene.displayPause()
                    break
                    
                case "quit":
                    print("buttonMenu Touched")
                    let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                    let gameScene = MapGame(fileNamed: "MapGame")
                    gameScene?.first = false
                    gameScene!.currentLevel = self.gameScene.currentLevel
                    self.gameScene.level.view!.removeFromSuperview()
                    self.view?.removeFromSuperview()
                    self.gameScene.view?.presentScene(gameScene!, transition: fadeScene)
                    break
                    
                default:
                    print("nn foi dessa vez")
                    
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    
    
}
