//
//  MapGame.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 21/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class MapGame: SKScene {
    
    var first: Bool!
    var currentLevel: Int!
    
    var touchRunning: Bool = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        addSwipes()
        
        if(currentLevel > 10){
            currentLevel = 10
        }
        var level: String!
        if(currentLevel < 10){
            level = "level" + "0" + String(currentLevel)
        }else{
            level = "level" + String(currentLevel)
        }
        if(first == true){
            self.camera!.yScale = 2
            self.camera!.xScale = 2
            self.camera!.position = CGPoint(x: 768, y: 1024)
            let zoomCamera = SKAction.scaleTo(1, duration: 1.5)
            self.camera!.runAction(zoomCamera)
        }
        centerOnNode(self.childNodeWithName(level)!.position)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if(!touchRunning){
            touchRunning = true
            
            for touch in touches {
                let location = touch.locationInNode(self)
                
                let body = self.nodeAtPoint(location)
                
                if let name: String = body.name {
                    switch name {
                        
                    case "backgroundMap":
                        touchRunning = false
                        break
                        
                    default:
                        self.view?.gestureRecognizers?.removeAll()
                        let index1 = name.startIndex.advancedBy(5)
                        let index2 = name.startIndex.advancedBy(6)
                        let numberLevel = Int(String(name[index1]))! * 10 + Int(String(name[index2]))!
                        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                            if (dictionary["currentLevel"] as! Int) >= numberLevel{
                                self.first = false
                                let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                                let gameScene = GameScene(fileNamed: "GameScene")
                                gameScene!.currentLevel = numberLevel
                                let level = "Level_" + String(name[index1]) + String(name[index2])
                                gameScene!.level = Level(filename: level)
                                self.view!.presentScene(gameScene!, transition: fadeScene)
                            }else{
                                //avisar que esse level não está liberado
                                print("não tá liberado")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func centerOnNode(position: CGPoint){
        var positionTest: CGPoint = CGPoint(x: 0, y: 0)
        let background = self.childNodeWithName("backgroundMap")
        
        if(position.x<384){
           positionTest.x = 384
        }else if(position.x > background!.frame.width - 384){
            positionTest.x = background!.frame.width - 384
        }else{
            positionTest.x = position.x
        }
        if(position.y<512){
            positionTest.y = 512
        }else if(position.y > background!.frame.height - 512){
            positionTest.y = background!.frame.height - 512
        }else{
            positionTest.y = position.y
        }
        
        let moveCamera = SKAction.moveTo(positionTest, duration: 1.5)
        self.camera!.runAction(moveCamera)
    }
    
    func updateButtonsScene(){
        let buttonEditAvatar = self.childNodeWithName("editAvatar") as! SKSpriteNode
        buttonEditAvatar.position.x = 50 + self.camera!.position.x - 256
    }
    
    func addSwipes(){
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view!.addGestureRecognizer(swipeRight)
    }
    
    func swipe(sender: UISwipeGestureRecognizer){
        /* Function to display the inventory */
        
        centerOnNode(CGPointMake(sender.locationInView(self.view).x, 768 - sender.locationInView(self.view).y))
    }
}

