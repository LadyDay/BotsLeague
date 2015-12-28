//
//  Base.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 12/27/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import SpriteKit

enum BaseType: Int, CustomStringConvertible {
    case Unknown = 0, baseWater, baseFire, baseMagnet, baseBolt
    
    var spriteName: String {
        let spriteNames = [
            "baseWater",
            "baseFire",
            "baseMagnet",
            "baseBolt"]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    var description: String {
        return spriteName
    }
}

class Base: CustomStringConvertible {
    let baseType: BaseType
    var sprite: SKSpriteNode?
    
    init(baseType: BaseType) {
        self.baseType = baseType
    }
    
    var description: String {
        return "type:\(baseType)"
    }
}
