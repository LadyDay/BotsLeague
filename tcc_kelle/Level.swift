//
//  Level.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 16/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

let NumColumns = 7
let NumRows = 7

class Level: SKScene {
    
    private var skills = Array2D<Skill>(columns: NumColumns, rows: NumRows)
    var durationSwipe: NSTimeInterval = 0.2
    var swipeEnablad: Bool = true
    var rows: Int = 0
    var columns: Int = 0
    
    func skillAtColumn(column: Int, row: Int) -> Skill? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return skills[column, row]
    }
    
    func shuffle() -> Set<Skill> {
        return createInitialSkills()
    }
    
    private func createInitialSkills() -> Set<Skill> {
        var set = Set<Skill>()
        
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // 2
                let skillType = SkillType.random()
                
                // 3
                let skill = Skill(column: column, row: row, skillType: skillType)
                skills[column, row] = skill
                
                // 4
                set.insert(skill)
            }
        }
        return set
    }
    
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
    
    func changeLots(sender: UISwipeGestureRecognizer, stringStop: Character, indexStringStop: Int, somaX: CGFloat, somaY: CGFloat){
        if(swipeEnablad){
            swipeEnablad = false
            let location = sender.locationOfTouch(0, inView: self.view)
            let position = CGPointMake(location.x, self.frame.height - location.y)
            
            let node1 = self.nodeAtPoint(position)
            let nameNode1 = node1.name!
            print("\(nameNode1)")
            
            let index = nameNode1.startIndex.advancedBy(indexStringStop)
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

