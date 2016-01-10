//
//  Edit.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 12/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class EditAvatar: SceneInterface {
    
    var currentLevel: Int!
    
    var currentRobot: Robot = Robot()
    var selectedPart: SKSpriteNode!
    
    var viewBox: UIView!
    
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
    var power: SKLabelNode!
    var money: SKLabelNode!
    var basedRobot: SKSpriteNode!
    
    //buttons
    var buttonMenu: SKSpriteNode!
    var buttonNext: SKSpriteNode!
    var buttonBack: SKSpriteNode!
    var buttonHome: SKSpriteNode!
    var buttonPower: SKSpriteNode!
    var buttonMoney: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        viewBox = UIView(frame: CGRectMake(80, 680, 602, 209))
        self.view?.addSubview(viewBox)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonNextPressed")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        viewBox.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonBackPressed")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        viewBox.addGestureRecognizer(swipeRight)
        
        let base = self.childNodeWithName("basedRobot") as! SKSpriteNode
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame") {
            let numberBase = dictionary["currentBase"] as! Int
            if(numberBase==1){
                base.texture = SKTexture(imageNamed: "baseWater")
            }else if(numberBase==2){
                base.texture = SKTexture(imageNamed: "baseFire")
            }else if(numberBase==3){
                base.texture = SKTexture(imageNamed: "baseMagnet")
            }else if(numberBase==4){
                base.texture = SKTexture(imageNamed: "baseBolt")
            }
            
        }
        
        self.selectedPart = self.childNodeWithName("head") as! SKSpriteNode
        initializeNodesInTheView()
        self.currentRobot.loadRobotFromFile()
        initializeTexturesOfLots()
        zerarAlphaRobot()
    }
    
    func positionLots(){
        let string = SKTexture.returnNameTexture(self.selectedPart.texture!)
        if(string[string.endIndex.predecessor()] == "l"){
            let numberTwo = Int(String(string[string.endIndex.predecessor().predecessor().predecessor().predecessor()]))
            colorPart2 = numberTwo!
            print(colorPart2)
            logicaNumber()
        }else{
            let numberTwo = Int(String(string[string.endIndex.predecessor()]))
            colorPart2 = numberTwo!
            print(colorPart2)
            logicaNumber()
        }
    }
    
    func logicaNumber(){
        if(colorPart2 - 1 == -1){
            colorPart = totalPieces - 1
        }else{
            colorPart = colorPart2 - 1
        }
        
        if(colorPart2 + 1 == totalPieces){
            colorPart3 = 0
        }else{
            colorPart3 = colorPart2 + 1
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
    }
    
    func initializeNodesInTheView(){
        //lots
        self.lotOne = self.childNodeWithName("lotOne") as! SKSpriteNode
        self.lotTwo = self.childNodeWithName("lotTwo") as! SKSpriteNode
        self.lotTree = self.childNodeWithName("lotTree") as! SKSpriteNode
        
        self.power = self.childNodeWithName("power") as! SKLabelNode
        self.money = self.childNodeWithName("money") as! SKLabelNode
        self.basedRobot = self.childNodeWithName("basedRobot") as! SKSpriteNode
        
        self.buttonMenu = self.childNodeWithName("buttonMenu") as! SKSpriteNode
        self.buttonNext = self.childNodeWithName("buttonNext") as! SKSpriteNode
        self.buttonBack = self.childNodeWithName("buttonBack") as! SKSpriteNode
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
    
    func zerarAlphaRobot(){
        highlightDeselectedParts({
            if(SKTexture.returnNameTexture(self.selectedPart.texture!)[SKTexture.returnNameTexture(self.selectedPart.texture!).endIndex.predecessor()] != "l"){
                let string = SKTexture.returnNameTexture(self.selectedPart.texture!) + "-hl"
                self.selectedPart.texture = SKTexture(imageNamed: string)
            }
        })
    }
    
    func highlightDeselectedParts(completion: (Void) -> Void){
        if(SKTexture.returnNameTexture(self.currentRobot.antenna.texture!)[SKTexture.returnNameTexture(self.currentRobot.antenna.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.antenna.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.antenna.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.antenna.texture!)[indexStart])
            }
            self.currentRobot.antenna.texture = SKTexture(imageNamed: string)
        }
        
        if(SKTexture.returnNameTexture(self.currentRobot.head.texture!)[SKTexture.returnNameTexture(self.currentRobot.head.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.head.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.head.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.head.texture!)[indexStart])
            }
            self.currentRobot.head.texture = SKTexture(imageNamed: string)
        }
        
        if(SKTexture.returnNameTexture(self.currentRobot.eyes.texture!)[SKTexture.returnNameTexture(self.currentRobot.eyes.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.eyes.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.eyes.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.eyes.texture!)[indexStart])
            }
            self.currentRobot.eyes.texture = SKTexture(imageNamed: string)
        }
        
        if(SKTexture.returnNameTexture(self.currentRobot.body.texture!)[SKTexture.returnNameTexture(self.currentRobot.body.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.body.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.body.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.body.texture!)[indexStart])
            }
            self.currentRobot.body.texture = SKTexture(imageNamed: string)
        }
        
        if(SKTexture.returnNameTexture(self.currentRobot.rightArm.texture!)[SKTexture.returnNameTexture(self.currentRobot.rightArm.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.rightArm.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.rightArm.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.rightArm.texture!)[indexStart])
            }
            self.currentRobot.rightArm.texture = SKTexture(imageNamed: string)
        }
        
        if(SKTexture.returnNameTexture(self.currentRobot.leftArm.texture!)[SKTexture.returnNameTexture(self.currentRobot.leftArm.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.leftArm.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.leftArm.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.leftArm.texture!)[indexStart])
            }
            self.currentRobot.leftArm.texture = SKTexture(imageNamed: string)
        }
        
        if(SKTexture.returnNameTexture(self.currentRobot.legs.texture!)[SKTexture.returnNameTexture(self.currentRobot.legs.texture!).endIndex.predecessor()] == "l"){
            let indexEnd = SKTexture.returnNameTexture(self.currentRobot.legs.texture!).endIndex.predecessor().predecessor().predecessor()
            var indexStart = SKTexture.returnNameTexture(self.currentRobot.legs.texture!).startIndex
            var string : String! = ""
            for( ;indexStart < indexEnd; indexStart++){
                string = string + String(SKTexture.returnNameTexture(self.currentRobot.legs.texture!)[indexStart])
            }
            self.currentRobot.legs.texture = SKTexture(imageNamed: string)
        }
        
        return completion()
    }
    
    func initializeTexturesOfNodesInView(){
        
        //buttons
        self.buttonMenu.texture = SKTexture(imageNamed: "buttonMenu")
        self.buttonNext.texture = SKTexture(imageNamed: "buttonNext")
        self.buttonBack.texture = SKTexture(imageNamed: "buttonBack")
        self.buttonPower.texture = SKTexture(imageNamed: "buttonPlus")
        self.buttonMoney.texture = SKTexture(imageNamed: "buttonPlus")
    }
    
    func initializeTexturesOfLots(){
        //lots
        positionLots()
        updateLots()
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
            
            let body = self.nodeAtPoint(location) as? SKSpriteNode
            
            if let name: String = body!.name {
                switch name {
                    
                case "antenna":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("antenna Touched")
                    self.selectedPart = self.currentRobot.antenna
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "head":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("head Touched")
                    self.selectedPart = self.currentRobot.head
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "eyes":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("eyes Touched")
                    self.selectedPart = self.currentRobot.eyes
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "body":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("body Touched")
                    self.selectedPart = self.currentRobot.body
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "rightArm":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    self.selectedPart = self.currentRobot.rightArm
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "leftArm":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    self.selectedPart = self.currentRobot.leftArm
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "legs":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("legs Touched")
                    self.selectedPart = self.currentRobot.legs
                    initializeTexturesOfLots()
                    zerarAlphaRobot()
                    break
                    
                case "buttonNext":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("buttonNext Touched")
                    buttonNextPressed()
                    break
                    
                case "buttonBack":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("buttonBack Touched")
                    buttonBackPressed()
                    break
                    
                case "buttonHome":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("buttonHome Touched")
                    goToHome()
                    break
                    
                case "buttonMenu":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("buttonMenu Touched")
                    displayMenu()
                    break
                    
                case "confirmar":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Confirmar.mp3", waitForCompletion: true))
                    }
                    
                    print("peca lotTwo confirmada")
                    self.selectedPart.blendMode = SKBlendMode.Alpha
                    self.confirmar()
                    goToHome()
                    break
                    
                case "cancelar":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("peca lotTwo confirmada")
                    self.cancelar()
                    goToHome()
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
        zerarAlphaRobot()
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
        zerarAlphaRobot()
    }
    
    func updateLots(){
        var stringColor: NSString = "square-" + self.selectedPart.name! + "-" + String(self.colorPart)
        self.lotOne.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = "square-" + self.selectedPart.name! + "-" + String(self.colorPart2)
        self.lotTwo.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = "square-" + self.selectedPart.name! + "-" + String(self.colorPart3)
        self.lotTree.texture = SKTexture(imageNamed: stringColor as String)
        
        stringColor = self.selectedPart.name! + "-" + String(self.colorPart2)
        self.selectedPart.texture = SKTexture(imageNamed: stringColor as String)
    }
    
    func goToHome(){
        viewBox.removeFromSuperview()
        
        let transition = SKTransition.crossFadeWithDuration(1.5)
        let mainScreen = Home(fileNamed: "Home")
        self.view?.presentScene(mainScreen!, transition: transition)
        mainScreen!.scaleMode = .AspectFill
    }
    
    func confirmar(){
        highlightDeselectedParts({
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("antenna"), object: SKTexture.returnNameTexture(self.currentRobot.antenna.texture!))
            
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("head"), object: SKTexture.returnNameTexture(self.currentRobot.head.texture!))
            
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("eyes"), object: SKTexture.returnNameTexture(self.currentRobot.eyes.texture!))
            
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("body"), object: SKTexture.returnNameTexture(self.currentRobot.body.texture!))
            
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("leftArm"), object: SKTexture.returnNameTexture(self.currentRobot.leftArm.texture!))
            
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("rightArm"), object: SKTexture.returnNameTexture(self.currentRobot.rightArm.texture!))
            
            Dictionary<String, AnyObject>.saveGameData("Robot", key: String.returnString("legs"), object: SKTexture.returnNameTexture(self.currentRobot.legs.texture!))
        })
    }
    
    func cancelar(){
        self.currentRobot.loadRobotFromFile()
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



