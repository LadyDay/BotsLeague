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
    
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    private var skills = Array2D<Skill>(columns: NumColumns, rows: NumRows)
    var durationSwipe: NSTimeInterval = 0.2
    var swipeEnablad: Bool = true
    var rows: Int = 0
    var columns: Int = 0
    
    let TileWidth: CGFloat = 83.0
    let TileHeight: CGFloat = 85.0
    
    var swipeFromColumn: Int?
    var swipeFromRow: Int?
    var swipeHandler: ((Swap) -> ())?
    
    var selectionSprite = SKSpriteNode()
    private var possibleSwaps = Set<Swap>()
    
    let swapSound = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false)
    let invalidSwapSound = SKAction.playSoundFileNamed("Erro.mp3", waitForCompletion: false)
    var matchSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
    let fallingCookieSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
    let addCookieSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
    
    init(filename: String) {
        super.init(size: CGSize(width: 631, height: 633))
        self.backgroundColor = UIColor.clearColor()
        self.blendMode = SKBlendMode.MultiplyX2
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
        // 1
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
            // 2
            if let tilesArray: AnyObject = dictionary["tiles"] {
                // 3
                for (row, rowArray) in (tilesArray as! [[Int]]).enumerate() {
                    // 4
                    let tileRow = NumRows - row - 1
                    // 5
                    for (column, value) in rowArray.enumerate() {
                        if value == 1 {
                            tiles[column, tileRow] = Tile()
                        }
                    }
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func skillAtColumn(column: Int, row: Int) -> Skill? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return skills[column, row]
    }
    
    func shuffle() -> Set<Skill> {
        var set: Set<Skill>
        repeat {
            set = createInitialSkills()
            detectPossibleSwaps()
            print("possible swaps: \(possibleSwaps)")
        }
            while possibleSwaps.count == 0
        
        return set
    }
    
    func isPossibleSwap(swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let skill = skills[column, row] {
                    
                    // Is it possible to swap this cookie with the one on the right?
                    if column < NumColumns - 1 {
                        // Have a cookie in this spot? If there is no tile, there is no cookie.
                        if let other = skills[column + 1, row] {
                            // Swap them
                            skills[column, row] = other
                            skills[column + 1, row] = skill
                            
                            // Is either cookie now part of a chain?
                            if hasChainAtColumn(column + 1, row: row) ||
                                hasChainAtColumn(column, row: row) {
                                    set.insert(Swap(skillA: skill, skillB: other))
                            }
                            
                            // Swap them back
                            skills[column, row] = skill
                            skills[column + 1, row] = other
                        }
                    }
                    
                    if row < NumRows - 1 {
                        if let other = skills[column, row + 1] {
                            skills[column, row] = other
                            skills[column, row + 1] = skill
                            
                            // Is either cookie now part of a chain?
                            if hasChainAtColumn(column, row: row + 1) ||
                                hasChainAtColumn(column, row: row) {
                                    set.insert(Swap(skillA: skill, skillB: other))
                            }
                            
                            // Swap them back
                            skills[column, row] = skill
                            skills[column, row + 1] = other
                        }
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    private func createInitialSkills() -> Set<Skill> {
        var set = Set<Skill>()
        
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // This line is new
                if tiles[column, row] != nil {
                    
                    // 2
                    var skillType: SkillType
                    repeat {
                        skillType = SkillType.random()
                        
                    }while (column >= 2 &&
                            skills[column - 1, row]?.skillType == skillType &&
                            skills[column - 2, row]?.skillType == skillType)
                            || (row >= 2 &&
                                skills[column, row - 1]?.skillType == skillType &&
                                skills[column, row - 2]?.skillType == skillType)
                    
                    // 3
                    let skill = Skill(column: column, row: row, skillType: skillType)
                    skills[column, row] = skill
                    
                    // 4
                    set.insert(skill)
                }
                
            }
        }
        return set
    }
    
    private func hasChainAtColumn(column: Int, row: Int) -> Bool {
        let skillType = skills[column, row]!.skillType
        
        var horzLength = 1
        for var i = column - 1; i >= 0 && skills[i, row]?.skillType == skillType;
            --i, ++horzLength { }
        for var i = column + 1; i < NumColumns && skills[i, row]?.skillType == skillType;
            ++i, ++horzLength { }
        if horzLength >= 3 { return true }
        
        var vertLength = 1
        for var i = row - 1; i >= 0 && skills[column, i]?.skillType == skillType;
            --i, ++vertLength { }
        for var i = row + 1; i < NumRows && skills[column, i]?.skillType == skillType;
            ++i, ++vertLength { }
        return vertLength >= 3
    }
    
    func showSelectionIndicatorForCookie(skill: Skill) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = skill.sprite {
            let texture = SKTexture(imageNamed: skill.skillType.highlightedSpriteName)
            selectionSprite.size = texture.size()
            selectionSprite.runAction(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()]))
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        // 2
        let (success, column, row) = convertPoint(location)
        if success {
            // 3
            if let skill = self.skillAtColumn(column, row: row) {
                showSelectionIndicatorForCookie(skill)
                // 4
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1
        if swipeFromColumn == nil { return }
        
        // 2
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        
        let (success, column, row) = convertPoint(location)
        if success {
            
            // 3
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horzDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
                horzDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                vertDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                vertDelta = 1
            }
            
            // 4
            if horzDelta != 0 || vertDelta != 0 {
                trySwapHorizontal(horzDelta, vertical: vertDelta)
                hideSelectionIndicator()
                
                // 5
                swipeFromColumn = nil
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesEnded(touches!, withEvent: event)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int) {
        // 1
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        // 2
        if toColumn < 0 || toColumn >= NumColumns { return }
        if toRow < 0 || toRow >= NumRows { return }
        // 3
        if let toSkill = self.skillAtColumn(toColumn, row: toRow) {
            if let fromSkill = self.skillAtColumn(swipeFromColumn!, row: swipeFromRow!) {
                // 4
                if let handler = swipeHandler {
                    let swap = Swap(skillA: fromSkill, skillB: toSkill)
                    handler(swap)
                }
            }
        }
    }
    
    func animateSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.skillA.sprite!
        let spriteB = swap.skillB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: NSTimeInterval = 0.3
        
        runAction(swapSound)
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        spriteA.runAction(moveA, completion: completion)
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        spriteB.runAction(moveB)
    }
    
    func animateInvalidSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.skillA.sprite!
        let spriteB = swap.skillB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: NSTimeInterval = 0.2
        
        runAction(invalidSwapSound)
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        
        spriteA.runAction(SKAction.sequence([moveA, moveB]), completion: completion)
        spriteB.runAction(SKAction.sequence([moveB, moveA]))
    }
    
    func performSwap(swap: Swap) {
        let columnA = swap.skillA.column
        let rowA = swap.skillA.row
        let columnB = swap.skillB.column
        let rowB = swap.skillB.row
        
        skills[columnA, rowA] = swap.skillB
        swap.skillB.column = columnA
        swap.skillB.row = rowA
        
        skills[columnB, rowB] = swap.skillA
        swap.skillA.column = columnB
        swap.skillA.row = rowB
    }
    
}

