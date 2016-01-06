//
//  Skill.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 19/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

enum SkillType: Int, CustomStringConvertible {
    case Unknown = 0, Water, Fire, Magnet, Bolt, Snow, Life
    
    var spriteName: String {
        let spriteNames = [
            "Water",
            "Fire",
            "Magnet",
            "Bolt",
            "Snow",
            "Life"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> SkillType {
        return SkillType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}

class Skill: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    let skillType: SkillType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, skillType: SkillType) {
        self.column = column
        self.row = row
        self.skillType = skillType
    }
    
    var description: String {
        return "type:\(skillType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
}

func ==(lhs: Skill, rhs: Skill) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
