//
//  GameScene.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameMatrix: Array = Array(count:6, repeatedValue:Array(count:7, repeatedValue:Int()))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let viewRecognizer: UIView = UIView(frame: CGRectMake(70, 350, 630, 560))
        self.view?.addSubview(viewRecognizer)
        
        /*
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        viewRecognizer.addGestureRecognizer(swipeDown)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        viewRecognizer.addGestureRecognizer(swipeUp)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        viewRecognizer.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        viewRecognizer.addGestureRecognizer(swipeRight)
        */
        updatingScenario()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
        }
        */
    }
    
    func updatingScenario(){
        var fail: Bool
        var num: UInt32
        
        for(var i = 0; i<7; i++){
            for(var j = 0; j<6; j++){
                repeat{
                    fail = false
                    num = arc4random_uniform(6)
                    if(j-2>=0){
                        if(gameMatrix[j-1][i]==Int(num) && gameMatrix[j-2][i]==Int(num)) {fail = true}
                    }
                    if(i-2>=0){
                        if(gameMatrix[j][i-1]==Int(num) && gameMatrix[j][i-2]==Int(num)) {fail = true}
                    }
                }while(fail)
                
                gameMatrix[j][i] = Int(num)
                let lot = self.childNodeWithName("lot\(j)\(i)") as! SKSpriteNode
                lot.texture = SKTexture(imageNamed: "peca\(gameMatrix[j][i])")
            }
        }
    }
    
    func swipeDown(sender: UISwipeGestureRecognizer){
        /* Function to display the inventory */
        let position = sender.locationInView(self.view)
        let node1 = self.nodeAtPoint(position)
        let nameNode1 = node1.name!
        
        /*
        if(Int(String(nameNode1[3])) != 5){
            let number: Int = String(nameNode1[3]).toInt()
            let node2 = self.childNodeWithName("lot"+"\(number)"+"\(nameNode1[4])")
            animationPieces(node1, anotherNode: node2)
        }
        */
    }
    
    func animationPieces(node: SKNode, anotherNode: SKNode){
        let positionAnotherNode: CGPoint = anotherNode.position
        while(node.position != positionAnotherNode){
            node.position.y--
            anotherNode.position.y++
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
