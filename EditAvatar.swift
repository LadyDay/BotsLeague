//
//  EditAvatar.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class EditAvatar: SKScene {
    
    var colorPart: NSInteger = 0
    var colorPart2: NSInteger = 1
    var colorPart3: NSInteger = 2
    var totalPieces: NSInteger = 5
    var homeScene: Home!
    
    //buttons
    var size_buttonNext: CGSize = CGSize(width: 30, height: 30)
    var size_buttonBack: CGSize = CGSize(width: 30, height: 30)
    var size_buttonBackHome: CGSize = CGSize(width: 50, height: 50)
    var size_buttonMenu: CGSize = CGSize(width: 50, height: 50)
    
    //information
    var size_battery: CGSize = CGSize(width: 80, height: 30)
    var size_money: CGSize = CGSize(width: 100, height: 30)
    
    var size_bodyPartsShelf: CGSize = CGSize(width: 330, height: 150)
    var size_lot: CGSize = CGSize(width: 100, height: 80)
    
    //robot

    var size_antenna: CGSize = CGSize(width: 50, height: 50)
    var size_head: CGSize = CGSize(width: 100, height: 80)
    var size_eyes: CGSize = CGSize(width: 50, height: 20)
    var size_rightArm: CGSize = CGSize(width: 30, height: 200)
    var size_leftArm: CGSize = CGSize(width: 30, height: 200)
    var size_legs: CGSize = CGSize(width: 100, height: 200)
    var size_body: CGSize = CGSize(width: 150, height: 180)

    
    var lotOne: SKSpriteNode = SKSpriteNode(imageNamed: "head-00")
    var lotTwo: SKSpriteNode = SKSpriteNode(imageNamed: "head-01")
    var lotTree: SKSpriteNode = SKSpriteNode(imageNamed: "head-02")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
/*        let background: SKSpriteNode = SKSpriteNode(imageNamed: "editAvatar_scenery")
        background.size = self.frame.size
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(background)
*/
        
        lotOne.name = "lotOne"
        lotTwo.name = "lotTwo"
        lotTree.name = "lotTree"
        
        compositionViewInfo()
        compositionParts()
        compositionViewButtons()
        compositionViewRobot()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let body = self.nodeAtPoint(location) as? SKSpriteNode {
                
                if let name: String = body.name {
                    switch name {
                        
                    case "buttonNext":
                        print("buttonNext Touched")
                        buttonNextPressed()
                        break
                        
                    case "buttonBack":
                        print("buttonBack Touched")
                        buttonBackPressed()
                        break
                        
                    case "buttonHome":
                        print("buttonHome Touched")
                        goToHome()
                        break
                        
                    case "buttonMenu":
                        print("buttonMenu Touched")
                        buttonBackPressed()
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
    
    func compositionViewButtons(){
        let buttonNext = SKSpriteNode(imageNamed: "buttonNext")
        buttonNext.name = "buttonNext"
        buttonNext.size = self.size_buttonNext
        buttonNext.position = CGPoint(x:345, y:105)
        
        let buttonBack = SKSpriteNode(imageNamed: "buttonBack")
        buttonBack.name = "buttonBack"
        buttonBack.size = self.size_buttonBack
        buttonBack.position = CGPoint(x:30, y:105)
        
        let buttonBackHome = SKSpriteNode(imageNamed: "buttonHome")
        buttonBackHome.name = "buttonHome"
        buttonBackHome.size = self.size_buttonBackHome
        buttonBackHome.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        let buttonMenu = SKSpriteNode(imageNamed: "buttonMenu")
        buttonMenu.name = "buttonMenu"
        buttonMenu.position = CGPoint(x:CGRectGetMaxX(self.frame)-25, y:CGRectGetMaxY(self.frame)-25)
        buttonMenu.size = self.size_buttonMenu
    
        self.addChild(buttonNext)
        self.addChild(buttonBack)
        self.addChild(buttonBackHome)
        self.addChild(buttonMenu)
    }
    
    func compositionViewInfo(){
        let battery = SKSpriteNode(imageNamed: "bg_energia_restante")
        battery.position = CGPoint(x:50, y:CGRectGetMaxY(self.frame)-20)
        battery.size = self.size_battery
        
        let money = SKSpriteNode(imageNamed: "bg_dinheiro_atual")
        money.position = CGPoint(x:battery.position.x+battery.size.width+30, y:CGRectGetMaxY(self.frame)-20)
        money.size = self.size_money
        
        let bodyPartsShelf = SKSpriteNode(imageNamed: "bodyPartsShelf")
        bodyPartsShelf.position = CGPoint(x: 188, y: 105)
        bodyPartsShelf.size = self.size_bodyPartsShelf
        
        self.addChild(bodyPartsShelf)
        self.addChild(battery)
        self.addChild(money)
    }
    
    func compositionParts(){
        self.lotOne.position = CGPoint(x: 75, y: 105)
        self.lotTwo.position = CGPoint(x: 175, y: 105)
        self.lotTree.position = CGPoint(x: 290, y: 105)
        self.lotOne.size = self.size_lot
        self.lotTwo.size = self.size_lot
        self.lotTree.size = self.size_lot
        
        self.addChild(self.lotOne)
        self.addChild(self.lotTwo)
        self.addChild(self.lotTree)
    }
    
    func compositionViewRobot(){
       /* let zoneRobot: SKSpriteNode = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: self.frame.size.width-72, height: self.frame.size.height-50))
        zoneRobot.position = CGPoint(x: 188, y: CGRectGetMaxY(self.frame)-100)
        self.addChild(zoneRobot)
        */
        
    }
    
    func buttonNextPressed(){
        self.colorPart += 1
        self.colorPart2 += 1
        self.colorPart3 += 1
        if(self.colorPart==self.totalPieces){
            self.colorPart = 0
        }
        if(self.colorPart2==self.totalPieces){
            self.colorPart2 = 0
        }
        if(self.colorPart3==self.totalPieces){
            self.colorPart3 = 0
        }
        
        var stringColor: NSString = "head-0" + String(self.colorPart)
        self.lotOne.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = "head-0" + String(self.colorPart2)
        self.lotTwo.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = "head-0" + String(self.colorPart3)
        self.lotTree.texture = SKTexture(imageNamed: stringColor as String)
    }
    
    func buttonBackPressed(){
        self.colorPart -= 1
        self.colorPart2 -= 1
        self.colorPart3 -= 1
        if(self.colorPart==(-1)){
            self.colorPart = self.totalPieces-1
        }
        if(self.colorPart2==(-1)){
            self.colorPart2 = self.totalPieces-1
        }
        if(self.colorPart3==(-1)){
            self.colorPart3 = self.totalPieces-1
        }
        
        var stringColor: NSString = "head-0" + String(self.colorPart)
        self.lotOne.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = "head-0" + String(self.colorPart2)
        self.lotTwo.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = "head-0" + String(self.colorPart3)
        self.lotTree.texture = SKTexture(imageNamed: stringColor as String)
    }
    
    func goToHome(){
        let gameView = self.view as SKView!
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        gameView.ignoresSiblingOrder = true
        
        self.homeScene = Home(size: gameView.bounds.size)
        gameView.presentScene(self.homeScene)
        self.homeScene.scaleMode = .AspectFill
    }
}


