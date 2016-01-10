//
//  Tutorial.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/4/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class Tutorial: SKScene {
    
    var robotSpriteArray = Array<SKTexture>()
    var robot: SKSpriteNode!
    var viewMensagem: TutorialView!
    
    var viewAux: SKView!
    
    var gameScene: MapGame!
    
    override func didMoveToView(view: SKView) {
        //tela de mensagem
        let viewAux = SKView(frame: CGRectMake(86.5, 70, 595, 555))
        self.view?.addSubview(viewAux as UIView)
        let transition = SKTransition.crossFadeWithDuration(2.5)
        self.viewMensagem = TutorialView(fileNamed: "TutorialView01")!
        self.viewAux = viewAux
        self.viewMensagem.tutorial = self
        viewAux.presentScene(self.viewMensagem, transition: transition)
        
        //robo
        robot = self.childNodeWithName("robot") as! SKSpriteNode
        robot.texture = SKTexture(imageNamed: "sprite1")
        initRobotSprites()
        initAnimationRobot()
    }
    
    func initRobotSprites(){
        robotSpriteArray.append(SKTexture(imageNamed: "sprite1"))
        robotSpriteArray.append(SKTexture(imageNamed: "sprite2"))
        robotSpriteArray.append(SKTexture(imageNamed: "sprite3"))
        robotSpriteArray.append(SKTexture(imageNamed: "sprite4"))
        robotSpriteArray.append(SKTexture(imageNamed: "sprite5"))
        robotSpriteArray.append(SKTexture(imageNamed: "sprite6"))
    }
    
    func initAnimationRobot(){
        let robotAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(robotSpriteArray, timePerFrame: 0.253))
        robot.runAction(robotAnimation)
    }
    
    func verificarView(){
        var scene: TutorialView!
        if(self.viewMensagem.numberView==1){
            scene = TutorialView(fileNamed: "TutorialView01")!
        }else if(self.viewMensagem.numberView==2){
            scene = TutorialView(fileNamed: "TutorialView02")!
        }else if(self.viewMensagem.numberView==3){
            scene = TutorialView(fileNamed: "TutorialView03")!
        }else{
            self.viewMensagem.comecaEssaPorra()
        }
        
        if(self.viewMensagem.numberView>=1 && self.viewMensagem.numberView<4){
            scene.selected = self.viewMensagem.selected
            scene.selectedBase = self.viewMensagem.selectedBase
            scene.numberView = self.viewMensagem.numberView
            scene.tutorial = self
            self.viewMensagem = scene
            
            self.viewAux.presentScene(self.viewMensagem)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}