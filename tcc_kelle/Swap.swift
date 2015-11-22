//
//  Swap.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 22/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

struct Swap: CustomStringConvertible, Hashable {
    let skillA: Skill
    let skillB: Skill
    
    init(skillA: Skill, skillB: Skill) {
        self.skillA = skillA
        self.skillB = skillB
    }
    
    var description: String {
        return "swap \(skillA) with \(skillB)"
    }
    
    var hashValue: Int {
        return skillA.hashValue ^ skillB.hashValue
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.skillA == rhs.skillA && lhs.skillB == rhs.skillB) ||
        (lhs.skillB == rhs.skillA && lhs.skillA == rhs.skillB)
}
