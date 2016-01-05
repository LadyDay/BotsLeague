//
//  GameWin.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/5/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class EndGame: SKScene {
    
    var currentLevel: Int!
    var myHighScore: Int!
    var currentScore: Int!
    var gamePlay: GameScene!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(gamePlay.level.fileName) {
            myHighScore = dictionary["myHighScore"] as! Int
        }
        
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame") {
            currentLevel = dictionary["currentLevel"] as! Int
        }
        
        let score = self.childNodeWithName("score") as! SKLabelNode
        score.text = String(currentScore)
        
        let highScore = self.childNodeWithName("myHighScore") as! SKLabelNode
        highScore.text = String(myHighScore)
        
        let nameLevel = self.childNodeWithName("nameLevel") as! SKLabelNode
        nameLevel.text = "Level " + String(gamePlay.level.fileName[gamePlay.level.fileName.endIndex.advancedBy(1)]) + String(gamePlay.level.fileName[gamePlay.level.fileName.endIndex.advancedBy(0)])
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let body = self.nodeAtPoint(location)
            
            if let name: String = body.name {
                switch name {
                    
                case "replay":
                    gamePlay.level.view!.removeFromSuperview()
                    let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                    let gameScene = MapGame(fileNamed: "MapGame")
                    gameScene!.first = true
                    if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                        gameScene!.currentLevel = dictionary["currentLevel"] as! Int
                    }
                    self.view?.presentScene(gameScene!, transition: fadeScene)
                    gameScene!.scaleMode = .AspectFill
                    break
                    
                case "proximo":
                    gamePlay.level.view!.removeFromSuperview()
                    let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                    let gameScene = MapGame(fileNamed: "MapGame")
                    gameScene!.first = true
                    if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                        gameScene!.currentLevel = dictionary["currentLevel"] as! Int
                    }
                    self.view?.presentScene(gameScene!, transition: fadeScene)
                    gameScene!.scaleMode = .AspectFill
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
