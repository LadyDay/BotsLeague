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
    
    func swipeUp(sender: UISwipeGestureRecognizer) {
        changeLots(sender, stringStop: "0", somaX: 0, somaY: 60, indexStringStop: 3)
    }
    
    func swipeDown(sender: UISwipeGestureRecognizer) {
        changeLots(sender, stringStop: Character("\(rows-1)"), somaX: 0, somaY: -60, indexStringStop: 3)
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        changeLots(sender, stringStop: "0", somaX: -60, somaY: 0, indexStringStop: 4)
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer) {
        changeLots(sender, stringStop: Character("\(columns-1)"), somaX: 60, somaY: 0, indexStringStop: 4)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

