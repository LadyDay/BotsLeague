//
//  MainScreen.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 11/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//
import SpriteKit

class MainScreen: SKScene {
    
    var editScene: Edit!
    
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
                        
                    case "buttonEditAvatar":
                        print("buttonNext Touched")
                        buttonEditAvatar()
                        break
                        
                    case "buttonPlay":
                        print("buttonBack Touched")
                        break
                    default:
                        print("nn foi dessa vez")
                        
                    }
                }
            }
        }
    }
    
    func buttonEditAvatar(){

        let gameView = self.view as SKView!
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        gameView.ignoresSiblingOrder = true
        
        self.editScene = Edit(size: gameView.bounds.size)
        gameView.presentScene(self.editScene)
        self.editScene.scaleMode = .AspectFill
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

