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
    
    func playSoundBackground(string: String){
        if(musicPermission()){
            let backgroundSound = SKAction.playSoundFileNamed(string, waitForCompletion: true)
            self.runAction(SKAction.repeatActionForever(backgroundSound), withKey: "soundBackground")
        }
    }
    
    func stopSoundBackground(){
        self.removeActionForKey("soundBackground")
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
