//
//  MapGame.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 21/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class MapGame: SceneInterface {
    
    var first: Bool!
    var currentLevel: Int!
    
    var touchRunning: Bool = false
    
    var doCentralize: Bool = false
    
    var viewTutorial: SKView!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if(!first){
            self.playSoundBackground("Principal")
        }
        
        self.doCentralize = true
        addSwipes()
        
        let mapInterface = self.childNodeWithName("mapInterface")!
        let powerInterface = self.childNodeWithName("powerInterface")!
        let moneyInterface = self.childNodeWithName("moneyInterface")!
        let powerLabel = self.childNodeWithName("powerLabel")!
        let moneyLabel = self.childNodeWithName("moneyLabel")!
        let buttonPower = self.childNodeWithName("buttonPower")!
        let buttonMoney = self.childNodeWithName("buttonMoney")!
        let buttonMenu = self.childNodeWithName("buttonMenu")!

        
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
            mapInterface.removeFromParent()
            powerInterface.removeFromParent()
            moneyInterface.removeFromParent()
            powerLabel.removeFromParent()
            moneyLabel.removeFromParent()
            buttonPower.removeFromParent()
            buttonMoney.removeFromParent()
            buttonMenu.removeFromParent()
            
            self.camera!.yScale = 2
            self.camera!.xScale = 2
            self.camera!.position = CGPoint(x: 768, y: 1024)
            let zoomCamera = SKAction.scaleTo(1, duration: 1.5)
            self.camera!.runAction(zoomCamera, completion: {
                self.addChild(mapInterface)
                self.addChild(powerInterface)
                self.addChild(moneyInterface)
                self.addChild(powerLabel)
                self.addChild(moneyLabel)
                self.addChild(buttonPower)
                self.addChild(buttonMoney)
                self.addChild(buttonMenu)
                
                if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame") {
                    if((dictionary["currentBase"] as! Int)==0){
                        self.displayTutorial()
                    }
                }
            })
        }
        centerOnNode(self.childNodeWithName(level)!.position)
    }
    
    func displayTutorial(){
        self.userInteractionEnabled = false
        self.viewTutorial = SKView(frame: CGRectMake(0, 0, 768, 1024))
        self.viewTutorial.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(self.viewTutorial as UIView)
        
        let transition = SKTransition.fadeWithDuration(10)
        let gameScene = Tutorial(fileNamed: "Tutorial")!
        gameScene.gameScene = self
        self.viewTutorial.presentScene(gameScene, transition: transition)
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
                        
                    case "buttonMenu":
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        
                        print("buttonMenu Touched")
                        displayMenu()
                        touchRunning = false
                        break
                        
                    case "backgroundMap":
                        touchRunning = false
                        break
                    
                    case "powerInterface":
                        touchRunning = false
                        break
                        
                    case "powerLabel":
                        touchRunning = false
                        break
                        
                    case "buttonPower":
                        touchRunning = false
                        break
                        
                    case "moneyInterface":
                        touchRunning = false
                        break
                        
                    case "moneyLabel":
                        touchRunning = false
                        break
                        
                    case "buttonMoney":
                        touchRunning = false
                        break
                        
                    case "buttonMenu":
                        touchRunning = false
                        break
                        
                    case "mapInterface":
                        touchRunning = false
                        break
                        
                    default:
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        self.stopSoundBackground()
                        
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
                                touchRunning = false
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
        if(self.doCentralize == true && first == false){
            updateButtonsScene()
        }
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
        
        self.doCentralize = true
        let moveCamera = SKAction.moveTo(positionTest, duration: 1.5)
        self.camera!.runAction(moveCamera, completion: {
            self.updateButtonsScene()
            self.doCentralize = false
        })
    }
    
    func updateButtonsScene(){
        let mapInterface = self.childNodeWithName("mapInterface")!
        let mapInterfaceGo = CGPoint(x: self.camera!.position.x - 384, y: self.camera!.position.y + 512)
        
        let powerInterface = self.childNodeWithName("powerInterface")!
        let powerInterfaceGo = CGPoint(x: self.camera!.position.x - 316, y: self.camera!.position.y + 482)
        
        let moneyInterface = self.childNodeWithName("moneyInterface")!
        let moneyInterfaceGo = CGPoint(x: self.camera!.position.x - 90, y: self.camera!.position.y + 482)
        
        let powerLabel = self.childNodeWithName("powerLabel")!
        let powerLabelGo = CGPoint(x: self.camera!.position.x - 311, y: self.camera!.position.y + 482)
        
        let moneyLabel = self.childNodeWithName("moneyLabel")!
        let moneyLabelGo = CGPoint(x: self.camera!.position.x - 120, y: self.camera!.position.y + 482)
        
        let buttonPower = self.childNodeWithName("buttonPower")!
        let buttonPowerGo = CGPoint(x: self.camera!.position.x - 236, y: self.camera!.position.y + 482)
        
        let buttonMoney = self.childNodeWithName("buttonMoney")!
        let buttonMoneyGo = CGPoint(x: self.camera!.position.x + 16, y: self.camera!.position.y + 482)
        
        let buttonMenu = self.childNodeWithName("buttonMenu")!
        let buttonMenuGo = CGPoint(x: self.camera!.position.x + 345, y: self.camera!.position.y + 482)
        
        mapInterface.runAction(SKAction.moveTo(mapInterfaceGo, duration: 0))
        powerInterface.runAction(SKAction.moveTo(powerInterfaceGo, duration: 0))
        moneyInterface.runAction(SKAction.moveTo(moneyInterfaceGo, duration: 0))
        powerLabel.runAction(SKAction.moveTo(powerLabelGo, duration: 0))
        moneyLabel.runAction(SKAction.moveTo(moneyLabelGo, duration: 0))
        buttonPower.runAction(SKAction.moveTo(buttonPowerGo, duration: 0))
        buttonMoney.runAction(SKAction.moveTo(buttonMoneyGo, duration: 0))
        buttonMenu.runAction(SKAction.moveTo(buttonMenuGo, duration: 0))
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
    
    func displayMenu(){
        boolMenu = true
        self.userInteractionEnabled = false
        self.viewMenu = SKView(frame: CGRectMake(0, 0, 768, 1024))
        self.viewMenu.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(self.viewMenu as UIView)
        
        let transition = SKTransition.crossFadeWithDuration(2)
        let gameScene = MenuView(fileNamed: "MenuView")!
        gameScene.gameScene = self
        viewMenu.presentScene(gameScene, transition: transition)
    }
}

