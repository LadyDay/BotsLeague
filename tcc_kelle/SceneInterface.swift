//
//  SceneInterface.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 1/8/16.
//  Copyright © 2016 LadyDay. All rights reserved.
//

import SpriteKit

class SceneInterface: SKScene {
    var boolMusic: Bool = false
    var boolEfects: Bool = false
    var audioNode: SKAudioNode!
    
    //menu
    var boolMenu: Bool = false
    var viewMenu: SKView!
    
    var boolPause: Bool = false
    var boolHierarquia: Bool = false
    var viewPause: SKView!
    var viewHierarquia: SKView!
    
    func playSoundBackground(string: String){
        if(musicPermission()){
            if(audioNode != nil){
                audioNode.runAction(SKAction.play())
                audioNode.runAction(SKAction.changeVolumeTo(0.1, duration: 0))
            }else{
                audioNode = SKAudioNode(fileNamed: string + ".mp3")
                audioNode.name = "soundBackground"
                audioNode.positional = false
                audioNode.autoplayLooped = true
                audioNode.runAction(SKAction.changeVolumeTo(0.1, duration: 0))
                self.addChild(audioNode)
            }
        }
    }
    
    func pauseSoundBackground(){
        if(audioNode != nil){
            audioNode.runAction(SKAction.changeVolumeTo(0, duration: 0), completion: {
                self.audioNode.runAction(SKAction.pause())
            })
        }
    }
    
    func stopSoundBackground(){
        if(audioNode != nil){
            audioNode.runAction(SKAction.changeVolumeTo(0, duration: 0), completion: {
                self.audioNode.runAction(SKAction.stop())
                self.audioNode.removeFromParent()
                self.audioNode = nil
            })
        }
    }
    
    func musicPermission() -> Bool{
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
            if((dictionary["boolMusic"] as! Bool) == true){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func efectsPermission() -> Bool{
        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
            if((dictionary["boolEfects"] as! Bool) == true){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
}
