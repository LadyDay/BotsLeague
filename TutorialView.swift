//
//  TutorialView.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/4/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class TutorialView: SKScene {
    
    var selected: SKSpriteNode = SKSpriteNode(imageNamed: "tutorial-selected")
    var selectedBase: Int!
    var numberView: Int = 1
    
    var tutorial: Tutorial!
    var viewAux: SKView!
    var background: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {

        self.background = self.childNodeWithName("background") as! SKSpriteNode
        comecaEssaPorra()
    }
    
    func comecaEssaPorra(){
        if(numberView>=3){
            let nameBackground = "tutorial0" + String(numberView)
            self.background.texture = SKTexture(imageNamed: nameBackground)
        }
        
        if(numberView==1){
            let body = self.childNodeWithName("fire") as! SKSpriteNode
            selectedBase = 2
            changePositionSelected(body)
        }
        
        if(numberView==2){
            let piece = self.childNodeWithName("peca") as! SKSpriteNode
            setTexture(piece)
        }
    }
    
    func changePositionSelected(body: SKSpriteNode){
        self.selected.removeFromParent()
        self.selected.position = body.position
        addChild(self.selected)
    }
    
    func setTexture(piece: SKSpriteNode){
        if(selectedBase==1){
            piece.texture = SKTexture(imageNamed: "tutorial-water")
        }else if(selectedBase==2){
            piece.texture = SKTexture(imageNamed: "tutorial-fire")
        }else if(selectedBase==3){
            piece.texture = SKTexture(imageNamed: "tutorial-magnet")
        }else if(selectedBase==4){
            piece.texture = SKTexture(imageNamed: "tutorial-bolt")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            let body = self.nodeAtPoint(location) as! SKSpriteNode
            
            if let name: String = body.name {
                switch name {
                    
                case "bolt":
                    print("bolt Touched")
                    self.selectedBase = 4
                    self.changePositionSelected(body)
                    break
                    
                case "fire":
                    print("fire Touched")
                    self.selectedBase = 2
                    self.changePositionSelected(body)
                    break
                    
                case "water":
                    print("water Touched")
                    self.selectedBase = 1
                    self.changePositionSelected(body)
                    break
                    
                case "magnet":
                    print("magnet Touched")
                    self.selectedBase = 3
                    self.changePositionSelected(body)
                    break
                    
                case "confirmar":
                    self.numberView++
                    if(numberView==9){
                        Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: String.returnString("currentBase"), object: self.selectedBase)
                        self.viewAux.removeFromSuperview()
                        
                        let transition = SKTransition.crossFadeWithDuration(1.5)
                        let mainScreen = Home(fileNamed: "Home")
                        self.tutorial.view!.presentScene(mainScreen!, transition: transition)
                        mainScreen!.scaleMode = .AspectFill
                    }else{
                        self.tutorial.verificarView()
                    }
                    break
                    
                case "cancelar":
                    self.numberView--
                    self.tutorial.verificarView()
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

