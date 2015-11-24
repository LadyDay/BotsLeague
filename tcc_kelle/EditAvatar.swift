//
//  Edit.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 12/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class EditAvatar: SKScene {
    
    var currentLevel: Int!
    
    var myRobot: Robot!
    var currentRobot: Robot = Robot()
    var selectedPart: SKSpriteNode!
    
    //informations of lots
    var colorPart: NSInteger = 0
    var colorPart2: NSInteger = 1
    var colorPart3: NSInteger = 2
    var totalPieces: NSInteger = 5

    //lots
    var lotOne: SKSpriteNode!
    var lotTwo: SKSpriteNode!
    var lotTree: SKSpriteNode!
    
    //cenary
    var power: SKSpriteNode!
    var money: SKSpriteNode!
    var armario: SKSpriteNode!
    var basedRobot: SKSpriteNode!
    
    //buttons
    var buttonMenu: SKSpriteNode!
    var buttonNext: SKSpriteNode!
    var buttonBack: SKSpriteNode!
    var buttonHome: SKSpriteNode!
    var buttonPower: SKSpriteNode!
    var buttonMoney: SKSpriteNode!
    
    //menu
    var boolMenu: Bool = false
    var viewMenu: SKView!
    
    override func didMoveToView(view: SKView) {
        
        let viewRecognizer: UIView = UIView(frame: CGRectMake(30, 770, 702, 209))
        self.view?.addSubview(viewRecognizer)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonNextPressed")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        viewRecognizer.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonBackPressed")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        viewRecognizer.addGestureRecognizer(swipeRight)
        
        self.selectedPart = self.childNodeWithName("head") as! SKSpriteNode
        initializeNodesInTheView()
        initializeTexturesOfNodesInView()
        initializeTexturesOfRobotAndLots()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
    }
    
    func initializeNodesInTheView(){
        //lots
        self.lotOne = self.childNodeWithName("lotOne") as! SKSpriteNode
        self.lotTwo = self.childNodeWithName("lotTwo") as! SKSpriteNode
        self.lotTree = self.childNodeWithName("lotTree") as! SKSpriteNode
        
        self.power = self.childNodeWithName("power") as! SKSpriteNode
        self.money = self.childNodeWithName("money") as! SKSpriteNode
        self.armario = self.childNodeWithName("armario") as! SKSpriteNode
        self.basedRobot = self.childNodeWithName("basedRobot") as! SKSpriteNode
        
        self.buttonMenu = self.childNodeWithName("buttonMenu") as! SKSpriteNode
        self.buttonNext = self.childNodeWithName("buttonNext") as! SKSpriteNode
        self.buttonBack = self.childNodeWithName("buttonBack") as! SKSpriteNode
        self.buttonHome = self.childNodeWithName("buttonHome") as! SKSpriteNode
        self.buttonPower = self.childNodeWithName("buttonPower") as! SKSpriteNode
        self.buttonMoney = self.childNodeWithName("buttonMoney") as! SKSpriteNode

        //parts of the robot
        self.currentRobot.antenna = childNodeWithName("antenna") as! SKSpriteNode
        self.currentRobot.head = childNodeWithName("head") as! SKSpriteNode
        self.currentRobot.eyes = childNodeWithName("eyes") as! SKSpriteNode
        self.currentRobot.body = childNodeWithName("body") as! SKSpriteNode
        self.currentRobot.rightArm = childNodeWithName("rightArm") as! SKSpriteNode
        self.currentRobot.leftArm = childNodeWithName("leftArm") as! SKSpriteNode
        self.currentRobot.legs = childNodeWithName("legs") as! SKSpriteNode
        
    }
    
    func initializeTexturesOfNodesInView(){
        //cenary
        self.power.texture = SKTexture(imageNamed: "bg_energia_restante")
        self.money.texture = SKTexture(imageNamed: "bg_dinheiro_atual")
        self.armario.texture = SKTexture(imageNamed: "bodyPartsShelf")
        self.basedRobot.texture = SKTexture(imageNamed: "basedRobot")
        
        //buttons
        self.buttonMenu.texture = SKTexture(imageNamed: "buttonMenu")
        self.buttonNext.texture = SKTexture(imageNamed: "buttonNext")
        self.buttonBack.texture = SKTexture(imageNamed: "buttonBack")
        self.buttonHome.texture = SKTexture(imageNamed: "buttonHome")
        self.buttonPower.texture = SKTexture(imageNamed: "buttonPlus")
        self.buttonMoney.texture = SKTexture(imageNamed: "buttonPlus")
    }
    
    func initializeTexturesOfRobotAndLots(){
        //lots
        updateLots()
        
        //parts of the robot
        self.currentRobot.antenna.texture = self.myRobot.antenna.texture
        self.currentRobot.head.texture = self.myRobot.head.texture
        self.currentRobot.eyes.texture = self.myRobot.eyes.texture
        self.currentRobot.body.texture = self.myRobot.body.texture
        self.currentRobot.rightArm.texture = self.myRobot.rightArm.texture
        self.currentRobot.leftArm.texture = self.myRobot.leftArm.texture
        self.currentRobot.legs.texture = self.myRobot.legs.texture

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
//        for touch in touches {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            //let body = self.nodeAtPoint(location) as? SKSpriteNode
            
            if let node = self.physicsWorld.bodyAtPoint(location)?.node {
                if(node.name == "antenna"){
                    print("passou pela antena")
                }
            }
            
        }
        
        
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            //let body = self.nodeAtPoint(location) as? SKSpriteNode
            
            if let node = self.physicsWorld.bodyAtPoint(location)?.node {
                if(node.name == "antenna"){
                    print("antenna Touched")
                    self.selectedPart = self.currentRobot.antenna
                    updateLots()
                
                }else{
            
                let body = self.nodeAtPoint(location) as? SKSpriteNode
                
                if let name: String = body!.name {
                    switch name {
                        
                    case "head":
                        print("head Touched")
                        self.selectedPart = self.currentRobot.head
                        updateLots()
                        break
                        
                    case "eyes":
                        print("eyes Touched")
                        self.selectedPart = self.currentRobot.eyes
                        updateLots()
                        break
                        
                    case "body":
                        print("body Touched")
                        self.selectedPart = self.currentRobot.body
                        updateLots()
                        break
                        
                    case "rightArm":
                        print("rightArm Touched")
                        self.selectedPart = self.currentRobot.rightArm
                        updateLots()
                        break
                        
                    case "leftArm":
                        print("leftArm Touched")
                        self.selectedPart = self.currentRobot.leftArm
                        updateLots()
                        break
                        
                    case "legs":
                        print("legs Touched")
                        self.selectedPart = self.currentRobot.legs
                        updateLots()
                        break
                        
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
                        goToMainScreen()
                        break
                        
                    case "buttonMenu":
                        print("buttonMenu Touched")
                        displayMenu()
                        break
                        
                    case "lotOne":
                        print("lotOne Touched")
                        self.selectedPart.texture = self.lotOne.texture
                        updateLots()
                        break
                        
                    case "lotTwo":
                        print("lotTwo Touched")
                        self.selectedPart.texture = self.lotTwo.texture
                        updateLots()
                        break
                        
                    case "lotTree":
                        print("lotTree Touched")
                        self.selectedPart.texture = self.lotTree.texture
                        updateLots()
                        break
                        
                    default:
                        print("nn foi dessa vez")

                    }
                }
                }
            }
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
        updateLots()
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
        updateLots()
        
    }
    
    func updateLots(){
        var stringColor: NSString = self.selectedPart.name! + "-0" + String(self.colorPart)
        self.lotOne.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = self.selectedPart.name! + "-0" + String(self.colorPart2)
        self.lotTwo.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = self.selectedPart.name! + "-0" + String(self.colorPart3)
        self.lotTree.texture = SKTexture(imageNamed: stringColor as String)
    }
    
    func goToMainScreen(){
        
        let transition = SKTransition.crossFadeWithDuration(1.5)
        let mainScreen = MainScreen(fileNamed: "MainScreen")
        mainScreen?.currentLevel = self.currentLevel
        mainScreen?.currentRobot = self.currentRobot
        self.view?.presentScene(mainScreen!, transition: transition)
        mainScreen!.scaleMode = .AspectFill
    }
    
    func displayMenu(){
        if(boolMenu){
            boolMenu = false
            self.viewMenu.removeFromSuperview()
        }else{
            boolMenu = true
            self.viewMenu = SKView(frame: CGRectMake(20, 20, (self.view?.frame.size.width)!-40, (self.view?.frame.height)!-40))
            self.view?.addSubview(self.viewMenu as UIView)
            
            let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 5)
            let gameScene: SKScene = MenuView(fileNamed: "MenuView")!
            viewMenu.presentScene(gameScene, transition: transition)
            
        }
    }
    
}



