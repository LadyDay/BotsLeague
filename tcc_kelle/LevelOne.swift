//
//  LevelOne.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 16/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

class LevelOne: Levels  {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.gameMatrix = Array<Array<Int>>(count:6, repeatedValue:Array<Int>(count:7, repeatedValue:Int()))
        self.rows = 6
        self.columns = 7
        addSwipes()
        
        updatingScenario(rows, columns: columns)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
        for touch in touches {
        let location = touch.locationInNode(self)
        }
        */
    }
    
    override func updatingScenario(rows: Int, columns: Int) {
        var fail: Bool
        var num: UInt32
        
        for(var i = 0; i<columns; i++){
            for(var j = 0; j<rows; j++){
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
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

