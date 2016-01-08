//
//  MenuView.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 02/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class MenuView: SceneInterface {
    
    var gameScene: SceneInterface!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame")
        self.boolMusic = dictionary!["boolMusic"] as! Bool
        self.boolEfects = dictionary!["boolEfects"] as! Bool
        spriteWithout()
    }
    
    func spriteWithout(){
        if(!self.boolMusic){
            let withoutMusic = SKSpriteNode(imageNamed: "menuImage-x")
            withoutMusic.name = "withoutMusic"
            withoutMusic.xScale = 0.3
            withoutMusic.yScale = 0.3
            withoutMusic.position = CGPoint(x: 207, y: 225)
            addChild(withoutMusic)
        }
        
        if(!self.boolEfects){
            let withoutEfects = SKSpriteNode(imageNamed: "menuImage-x")
            withoutEfects.name = "withoutEfects"
            withoutEfects.xScale = 0.3
            withoutEfects.yScale = 0.3
            withoutEfects.position = CGPoint(x: 106, y: 225)
            addChild(withoutEfects)
        }
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
                    
                case "efects":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    if(!self.boolEfects){
                        let without = self.childNodeWithName("withoutEfects")!
                        without.removeFromParent()
                    }
                    self.boolEfects = !self.boolEfects
                    Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: "boolEfects", object: self.boolEfects)
                    spriteWithout()
                    break
                    
                case "withoutEfects":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    body?.removeFromParent()
                    self.boolEfects = !self.boolEfects
                    Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: "boolEfects", object: self.boolEfects)
                    break
                    
                case "music":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    if(!self.boolMusic){
                        let without = self.childNodeWithName("withoutMusic")!
                        without.removeFromParent()
                        gameScene.playSoundBackground("Principal")
                    }else{
                        gameScene.stopSoundBackground()
                    }
                    self.boolMusic = !self.boolMusic
                    Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: "boolMusic", object: self.boolMusic)
                    spriteWithout()
                    break
                    
                case "withoutMusic":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    body?.removeFromParent()
                    self.boolMusic = !self.boolMusic
                    Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: "boolMusic", object: self.boolMusic)
                    break
                    
                case "credits":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    print("buttonCredits Touched")
                    break
                    
                case "logout":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    print("buttonLogout Touched")
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