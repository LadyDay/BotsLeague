//
//  MainScreen.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 11/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//
import SpriteKit

class MainScreen: SKScene {
    
    var myRobot: Robot?
    var currentRobot: Robot?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if(myRobot == nil){
            myRobot = Robot()
        }
        
        if(currentRobot == nil){
            currentRobot = Robot()
        }
        
        initializeRobot()
        initializeTexturesOfRobot()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let body = self.nodeAtPoint(location) as? SKSpriteNode {
                
                if let name: String = body.name {
                    switch name {
                        
                    case "buttonEditAvatar":
                        print("buttonNext Touched")
                        buttonEditAvatar()
                        break
                        
                    case "buttonPlay":
                        print("buttonBack Touched")
                        buttonPlay()
                        break
                    default:
                        print("nn foi dessa vez")
                        
                    }
                }
            }
        }
    }
    
    func initializeRobot(){
        //parts of the robot
        self.myRobot!.antenna = childNodeWithName("antenna") as! SKSpriteNode
        self.myRobot!.head = childNodeWithName("head") as! SKSpriteNode
        self.myRobot!.eyes = childNodeWithName("eyes") as! SKSpriteNode
        self.myRobot!.body = childNodeWithName("body") as! SKSpriteNode
        self.myRobot!.rightArm = childNodeWithName("rightArm") as! SKSpriteNode
        self.myRobot!.leftArm = childNodeWithName("leftArm") as! SKSpriteNode
        self.myRobot!.legs = childNodeWithName("legs") as! SKSpriteNode
    }
    
    func initializeTexturesOfRobot(){
        //parts of the robot
        repeat{
            self.myRobot!.antenna.texture = self.currentRobot!.antenna.texture
        }while(self.myRobot!.antenna.texture == nil)
        
        repeat{
            self.myRobot!.head.texture = self.currentRobot!.head.texture
        }while(self.myRobot!.head.texture == nil)
        
        repeat{
            self.myRobot!.eyes.texture = self.currentRobot!.eyes.texture
        }while(self.myRobot!.eyes.texture == nil)
        
        repeat{
            self.myRobot!.body.texture = self.currentRobot!.body.texture
        }while(self.myRobot!.body.texture == nil)
        
        repeat{
            self.myRobot!.rightArm.texture = self.currentRobot!.rightArm.texture
        }while(self.myRobot!.rightArm.texture == nil)
        
        repeat{
            self.myRobot!.leftArm.texture = self.currentRobot!.leftArm.texture
        }while(self.myRobot!.leftArm.texture == nil)
        
        repeat{
            self.myRobot!.legs.texture = self.currentRobot!.legs.texture
        }while(self.myRobot!.legs.texture == nil)

    }
    
    func buttonPlay(){
        
        let transition = SKTransition.crossFadeWithDuration(1.5)
        let scene = GameScene(fileNamed: "GameScene")
        self.view?.presentScene(scene!, transition: transition)
        scene!.scaleMode = .AspectFill
    }
    
    func buttonEditAvatar(){
        
        let transition = SKTransition.crossFadeWithDuration(1.5)
        let scene = EditAvatar(fileNamed: "EditAvatar")
        scene?.myRobot = self.myRobot
        self.view?.presentScene(scene!, transition: transition)
        scene!.scaleMode = .AspectFill
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

