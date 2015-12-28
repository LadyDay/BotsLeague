//
//  Home.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class Home: SKScene {

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let body = self.nodeAtPoint(location) as? SKSpriteNode {
                
                if let name: String = body.name {
                    switch name {
                        
                    case "buttonFacebook":
                        
                        print("buttonFacebook Touched")
                        
                        break
                        
                    case "buttonConfiguration":
                        
                        print("buttonConfiguration Touched")
                        
                        break
                        
                    case "buttonStart":
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = MapGame(fileNamed: "MapGame")
                        gameScene!.first = true
                        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                            gameScene!.currentLevel = dictionary["currentLevel"] as! Int
                        }
                        self.view?.presentScene(gameScene!, transition: fadeScene)
                        gameScene!.scaleMode = .AspectFill
                        
                        break
                        
                    case "buttonEditAvatar":
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = EditAvatar(fileNamed: "EditAvatar")
                        self.view?.presentScene(gameScene!, transition: fadeScene)
                        gameScene!.scaleMode = .AspectFill
                        
                        break
                        
                    default:
                        
                        print("nn foi dessa vez")
                        
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    

}

