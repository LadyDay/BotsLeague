//
//  MyButtonNode.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 11/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class MyButtonNode: SKSpriteNode{
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        print("começou o toque")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        print("terminou o toque")
    }
}