//
//  MapGame.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 21/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class MapGame: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        centerOnNode(self.childNodeWithName("level1")!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let body = self.nodeAtPoint(location) as? SKSpriteNode {
                
                if let name: String = body.name {
                    switch name {
                        
                    case "editAvatar":
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = MainScreen(fileNamed: "MainScreen")
                        self.view?.presentScene(gameScene!, transition: fadeScene)
                        gameScene!.scaleMode = .AspectFill
                        
                        break
                        
                    default:
                        //let index = name.startIndex.advancedBy(5)
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = GameScene(fileNamed: "GameScene")
                        gameScene?.level = Level(filename: "Level_1")
                        self.view?.presentScene(gameScene!, transition: fadeScene)
                        gameScene!.scaleMode = .AspectFill
                        print("nn foi dessa vez")
                        
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func centerOnNode(node:SKNode){
        var position: CGPoint = CGPoint(x: 0, y: 0)
        let background = self.childNodeWithName("backgroundMap")
        
        if(node.position.x<384){
           position.x = 384
        }else if(node.position.x > background!.frame.width - 384){
            position.x = background!.frame.width - 384
        }else{
            position.x = node.position.x
        }
        if(node.position.y<512){
            position.y = 512
        }else if(node.position.y > background!.frame.height - 512){
            position.y = background!.frame.height - 512
        }else{
            position.y = node.position.y
        }
        
        let moveCamera = SKAction.moveTo(position, duration: 1.5)
        let zoomCamera = SKAction.scaleTo(1, duration: 1.5)
        self.camera!.runAction(SKAction.group([moveCamera, zoomCamera]))
    }
    
    func updateButtonsScene(){
        let buttonEditAvatar = self.childNodeWithName("editAvatar") as! SKSpriteNode
        buttonEditAvatar.position.x = 50 + self.camera!.position.x - 512
    }
    
}

