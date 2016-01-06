//
//  Chain.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 22/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import Foundation

class Chain: Hashable, CustomStringConvertible {
    var skills = [Skill]()
    var chainType: ChainType
    var score = 0
    
    enum ChainType: CustomStringConvertible {
        case Horizontal
        case Vertical
        
        var description: String {
            switch self {
            case .Horizontal: return "Horizontal"
            case .Vertical: return "Vertical"
            }
        }
    }
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addSkill(skill: Skill) {
        skills.append(skill)
    }
    
    func firstSkill() -> Skill {
        return skills[0]
    }
    
    func lastSkill() -> Skill {
        return skills[skills.count - 1]
    }
    
    var length: Int {
        return skills.count
    }
    
    var description: String {
        return "type:\(chainType) skills:\(skills)"
    }
    
    var hashValue: Int {
        return skills.reduce(0, combine: { $0.hashValue ^ $1.hashValue })
        //return skills.reduce(skills, 0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.skills == rhs.skills
}
