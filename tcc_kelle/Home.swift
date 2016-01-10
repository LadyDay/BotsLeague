//
//  Home.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class Home: SceneInterface {
    
    var logoSpriteArray = Array<SKTexture>()
    var logo: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.playSoundBackground("Principal")
        //robo
        logo = self.childNodeWithName("logo") as! SKSpriteNode
        logo.texture = SKTexture(imageNamed: "logoHome1")
        initLogoSprites()
        initAnimationLogo()
    }
    
    func initLogoSprites(){
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome1"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome2"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome3"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome4"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome5"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome6"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome7"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome8"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome9"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome10"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome11"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome12"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome13"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome14"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome15"))
        logoSpriteArray.append(SKTexture(imageNamed: "logoHome16"))
    }
    
    func initAnimationLogo(){
        let logoAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(logoSpriteArray, timePerFrame: 0.2))
        logo.runAction(logoAnimation)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let body = self.nodeAtPoint(location) as? SKSpriteNode {
                
                if let name: String = body.name {
                    switch name {
                        
                    case "buttonFacebook":
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        
                        print("buttonFacebook Touched")
                        
                        break
                        
                    case "buttonConfiguration":
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        
                        print("buttonConfiguration Touched")
                        displayMenu()
                        break
                        
                    case "buttonStart":
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = MapGame(fileNamed: "MapGame")
                        gameScene!.first = true
                        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                            gameScene!.currentLevel = dictionary["currentLevel"] as! Int
                        }
                        self.view?.presentScene(gameScene!, transition: fadeScene)
                        
                        break
                        
                    case "buttonEditAvatar":
                        if(efectsPermission()){
                            runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                        }
                        self.stopSoundBackground()
                        
                        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
                        let gameScene = EditAvatar(fileNamed: "EditAvatar")
                        self.view?.presentScene(gameScene!, transition: fadeScene)
                        
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
    
    func displayMenu(){
        boolMenu = true
        self.userInteractionEnabled = false
        self.viewMenu = SKView(frame: CGRectMake(0, 0, 768, 1024))
        self.viewMenu.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(self.viewMenu as UIView)
        
        let transition = SKTransition.crossFadeWithDuration(2)
        let gameScene = MenuView(fileNamed: "MenuViewHome")!
        gameScene.gameScene = self
        viewMenu.presentScene(gameScene, transition: transition)
    }
}

