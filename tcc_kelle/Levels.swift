//
//  Levels.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 16/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class Levels: SKScene {
    
    var gameMatrix: Array<Array<Int>>!
    var durationSwipe: NSTimeInterval = 0.2
    var swipeEnablad: Bool = true
    var rows: Int = 0
    var columns: Int = 0
    
    func addSwipes(){
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view!.addGestureRecognizer(swipeRight)
    }
    
    func updatingScenario(rows: Int, columns: Int){
        
    }
    
    func swipeUp(sender: UISwipeGestureRecognizer){
        /* Function to display the inventory */
        if(swipeEnablad){
            swipeEnablad = false
            let location = sender.locationOfTouch(0, inView: self.view)
            let position = CGPointMake(location.x, self.frame.height - location.y)
            
            let node1 = self.nodeAtPoint(position)
            let nameNode1 = node1.name!
            print("\(nameNode1)")
            
            let index = nameNode1.startIndex.advancedBy(3)
            if(nameNode1[index] != "0"){
                let node2 = self.nodeAtPoint(CGPointMake(node1.position.x, node1.position.y + 60))
                let nameNode2 = node2.name!
                print("\(nameNode2)")
                
                let index1 = nameNode1.startIndex.advancedBy(0)
                let index2 = nameNode2.startIndex.advancedBy(0)
                if(nameNode1[index1]=="l" && nameNode2[index2]=="l"){
                    
                    let positionNode1: CGPoint = node1.position
                    let positionNode2: CGPoint = node2.position
                    
                    let animationNode1 = SKAction.moveTo(positionNode2, duration: self.durationSwipe)
                    let animationNode2 = SKAction.moveTo(positionNode1, duration: self.durationSwipe)
                    node1.runAction(animationNode1, completion: {
                        self.swipeEnablad = true
                    })
                    node2.runAction(animationNode2)
                    node1.name = nameNode2
                    node2.name = nameNode1
                }else{
                    self.swipeEnablad = true
                }
            }else{
                self.swipeEnablad = true
            }
        }
    }
    
    func swipeDown(sender: UISwipeGestureRecognizer){
        /* Function to display the inventory */
        if(swipeEnablad){
            swipeEnablad = false
            let location = sender.locationOfTouch(0, inView: self.view)
            let position = CGPointMake(location.x, self.frame.height - location.y)
            
            let node1 = self.nodeAtPoint(position)
            let nameNode1 = node1.name!
            print("\(nameNode1)")
            
            let index = nameNode1.startIndex.advancedBy(3)
            if(nameNode1[index] != Character("\(rows-1)")){
                let node2 = self.nodeAtPoint(CGPointMake(node1.position.x, node1.position.y - 60))
                let nameNode2 = node2.name!
                print("\(nameNode2)")
                
                let index1 = nameNode1.startIndex.advancedBy(0)
                let index2 = nameNode2.startIndex.advancedBy(0)
                if(nameNode1[index1]=="l" && nameNode2[index2]=="l"){
                    
                    let positionNode1: CGPoint = node1.position
                    let positionNode2: CGPoint = node2.position
                    
                    let animationNode1 = SKAction.moveTo(positionNode2, duration: self.durationSwipe)
                    let animationNode2 = SKAction.moveTo(positionNode1, duration: self.durationSwipe)
                    node1.runAction(animationNode1, completion: {
                        self.swipeEnablad = true
                    })
                    node2.runAction(animationNode2)
                    node1.name = nameNode2
                    node2.name = nameNode1
                }else{
                    self.swipeEnablad = true
                }
            }else{
                self.swipeEnablad = true
            }
        }
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer){
        if(swipeEnablad){
            swipeEnablad = false
            let location = sender.locationOfTouch(0, inView: self.view)
            let position = CGPointMake(location.x, self.frame.height - location.y)
            
            let node1 = self.nodeAtPoint(position)
            let nameNode1 = node1.name!
            print("\(nameNode1)")
            
            let index = nameNode1.startIndex.advancedBy(4)
            if(nameNode1[index] != Character("\(columns-1)")){
                let node2 = self.nodeAtPoint(CGPointMake(node1.position.x + 60, node1.position.y))
                let nameNode2 = node2.name!
                print("\(nameNode2)")
                
                let index1 = nameNode1.startIndex.advancedBy(0)
                let index2 = nameNode2.startIndex.advancedBy(0)
                if(nameNode1[index1]=="l" && nameNode2[index2]=="l"){
                    
                    let positionNode1: CGPoint = node1.position
                    let positionNode2: CGPoint = node2.position
                    
                    let animationNode1 = SKAction.moveTo(positionNode2, duration: self.durationSwipe)
                    let animationNode2 = SKAction.moveTo(positionNode1, duration: self.durationSwipe)
                    node1.runAction(animationNode1, completion: {
                        self.swipeEnablad = true
                    })
                    node2.runAction(animationNode2)
                    node1.name = nameNode2
                    node2.name = nameNode1
                }else{
                    self.swipeEnablad = true
                }
            }else{
                self.swipeEnablad = true
            }
        }
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer){
        if(swipeEnablad){
            swipeEnablad = false
            let location = sender.locationOfTouch(0, inView: self.view)
            let position = CGPointMake(location.x, self.frame.height - location.y)
            
            let node1 = self.nodeAtPoint(position)
            let nameNode1 = node1.name!
            print("\(nameNode1)")
            
            let index = nameNode1.startIndex.advancedBy(4)
            if(nameNode1[index] != "0"){
                let node2 = self.nodeAtPoint(CGPointMake(node1.position.x - 60, node1.position.y))
                let nameNode2 = node2.name!
                print("\(nameNode2)")
                
                let index1 = nameNode1.startIndex.advancedBy(0)
                let index2 = nameNode2.startIndex.advancedBy(0)
                if(nameNode1[index1]=="l" && nameNode2[index2]=="l"){
                    
                    let positionNode1: CGPoint = node1.position
                    let positionNode2: CGPoint = node2.position
                    
                    let animationNode1 = SKAction.moveTo(positionNode2, duration: self.durationSwipe)
                    let animationNode2 = SKAction.moveTo(positionNode1, duration: self.durationSwipe)
                    node1.runAction(animationNode1, completion: {
                        self.swipeEnablad = true
                    })
                    node2.runAction(animationNode2)
                    node1.name = nameNode2
                    node2.name = nameNode1
                }else{
                    self.swipeEnablad = true
                }
            }else{
                self.swipeEnablad = true
            }
        }
    }
    
    func changeLots(sender: UISwipeGestureRecognizer, stringStop: Character, somaX: CGFloat, somaY: CGFloat){
        if(swipeEnablad){
            swipeEnablad = false
            let location = sender.locationOfTouch(0, inView: self.view)
            let position = CGPointMake(location.x, self.frame.height - location.y)
            
            let node1 = self.nodeAtPoint(position)
            let nameNode1 = node1.name!
            print("\(nameNode1)")
            
            let index = nameNode1.startIndex.advancedBy(4)
            if(nameNode1[index] != stringStop){
                let node2 = self.nodeAtPoint(CGPointMake(node1.position.x + somaX, node1.position.y + somaY))
                let nameNode2 = node2.name!
                print("\(nameNode2)")
                
                let index1 = nameNode1.startIndex.advancedBy(0)
                let index2 = nameNode2.startIndex.advancedBy(0)
                if(nameNode1[index1]=="l" && nameNode2[index2]=="l"){
                    
                    let positionNode1: CGPoint = node1.position
                    let positionNode2: CGPoint = node2.position
                    
                    let animationNode1 = SKAction.moveTo(positionNode2, duration: self.durationSwipe)
                    let animationNode2 = SKAction.moveTo(positionNode1, duration: self.durationSwipe)
                    node1.runAction(animationNode1, completion: {
                        self.swipeEnablad = true
                    })
                    node2.runAction(animationNode2)
                    node1.name = nameNode2
                    node2.name = nameNode1
                }else{
                    self.swipeEnablad = true
                }
            }else{
                self.swipeEnablad = true
            }
        }
    }
    
}

