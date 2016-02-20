//
//  GameWin.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/5/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class EndGame: SceneInterface {
    
    var currentLevel: Int!
    var myHighScore: Int!
    var currentScore: Int!
    var gamePlay: GameScene!
    var win: Bool!
    
    var touchRunning: Bool = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("MyHighScores") {
            myHighScore = dictionary[gamePlay.level.fileName] as! Int
        }
        
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame") {
            currentLevel = dictionary["currentLevel"] as! Int
        }
        
        if(win == true){
            if(currentScore > myHighScore){
                Dictionary<String, AnyObject>.saveGameData("MyHighScores", key: gamePlay.level.fileName, object: currentScore)
                myHighScore = currentScore
            }
        }
        
        let score = self.childNodeWithName("score") as! SKLabelNode
        score.text = String(currentScore)
        
        let highScore = self.childNodeWithName("myHighScore") as! SKLabelNode
        highScore.text = String(myHighScore)
        
        
        let nameLevel = self.childNodeWithName("nameLevel") as! SKLabelNode
        nameLevel.text = "Level " + String(gamePlay.level.fileName[gamePlay.level.fileName.endIndex.predecessor().predecessor()]) + String(gamePlay.level.fileName[gamePlay.level.fileName.endIndex.predecessor()])
        
        touchRunning = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if(!touchRunning){
            touchRunning = true
            for touch in touches {
                let location = touch.locationInNode(self)
                
                let body = self.nodeAtPoint(location)
                
                if let name: String = body.name {
                    switch name {
                        
                    case "replay":
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        
                        gamePlay.level.view!.removeFromSuperview()
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = GameScene(fileNamed: "GameScene")
                        gameScene!.currentLevel = gamePlay.currentLevel
                        let level = gamePlay.level.fileName
                        gameScene!.level = Level(filename: level)
                        gamePlay.view!.presentScene(gameScene!, transition: fadeScene)
                        gameScene!.scaleMode = .AspectFill
                        self.view!.removeFromSuperview()
                        
                        break
                        
                    case "proximo":
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        
                        gamePlay.level.view!.removeFromSuperview()
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = MapGame(fileNamed: "MapGame")
                        gameScene!.first = false
                        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                            gameScene!.currentLevel = dictionary["currentLevel"] as! Int
                        }
                        gamePlay.view!.presentScene(gameScene!, transition: fadeScene)
                        gameScene!.scaleMode = .AspectFill
                        self.view!.removeFromSuperview()
                        
                        break
                        
                    default:
                        touchRunning = false
                        break
                    }
                }
            }

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
