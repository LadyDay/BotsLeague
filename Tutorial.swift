//
//  Tutorial.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/4/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class Tutorial: SKScene {
    
    var robot: SKSpriteNode!
    var viewMensagem: TutorialView!
    
    override func didMoveToView(view: SKView) {
        //tela de mensagem
        let viewAux = SKView(frame: CGRectMake(86.5, 70, 595, 555))
        self.view?.addSubview(viewAux as UIView)
        let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 10)
        self.viewMensagem = TutorialView(fileNamed: "TutorialView01")!
        self.viewMensagem.viewAux = viewAux
        self.viewMensagem.tutorial = self
        viewAux.presentScene(self.viewMensagem, transition: transition)
        
        //robo
    }
    
    func verificarView(){
        var gameScene: TutorialView
        if(self.viewMensagem.numberView==1){
            gameScene = TutorialView(fileNamed: "TutorialView01")!
        }else if(self.viewMensagem.numberView==2){
            gameScene = TutorialView(fileNamed: "TutorialView02")!
        }else{
            gameScene = TutorialView(fileNamed: "TutorialView03")!
        }
        
        gameScene.selected = self.viewMensagem.selected
        gameScene.selectedBase = self.viewMensagem.selectedBase
        gameScene.numberView = self.viewMensagem.numberView
        gameScene.tutorial = self
        self.viewMensagem.viewAux.removeFromSuperview()
        self.viewMensagem = gameScene
        
        let viewAux = SKView(frame: CGRectMake(86.5, 70, 595, 555))
        self.view?.addSubview(viewAux as UIView)
        gameScene.viewAux = viewAux
        let transition = SKTransition.crossFadeWithDuration(10)
        viewAux.presentScene(gameScene, transition: transition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}