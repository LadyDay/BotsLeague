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

class Level: SceneInterface {
    
    var fileName: String!
    
    var totalLifeAvatar: Int!
    var totalLifeEnemy: Int!
    
    var lifeAvatar = 0
    var lifeEnemy = 0
    
    var basedRobot: Base!
    var basedEnemy: Base!
    
    var currentPlayer: Bool = true
    var firstEnemyPlay = true
    
    var bgEnemyPresent: SKView!
    var movesToEnemy = 0
    var maximumMovesToEnemy = 0
    
    var zPositionSkillA: CGFloat = 100
    var zPositionSkillB: CGFloat = 90
    
    var comboMultiplier = 0
    
    var offsetTiles: CGFloat = 0.0
    
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    private var skills = Array2D<Skill>(columns: NumColumns, rows: NumRows)
    var durationSwipe: NSTimeInterval = 0.2
    var swipeEnablad: Bool = true
    var rows: Int = 0
    var columns: Int = 0
    
    let TileWidth: CGFloat = 86.0
    let TileHeight: CGFloat = 86.0
    
    var swipeFromColumn: Int?
    var swipeFromRow: Int?
    var swipeHandler: ((Swap) -> ())?
    
    var selectionSprite = SKSpriteNode()
    var possibleSwaps = Set<Swap>()
    
    var matchSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
    let fallingSkillSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
    let addSkillSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
    
    init(filename: String) {
        super.init(size: CGSize(width: 602, height: 602))
        self.fileName = filename
        self.backgroundColor = UIColor.clearColor()
        self.blendMode = SKBlendMode.MultiplyX2
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
        // 1
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
            // 2
            if let tilesArray: AnyObject = dictionary["tiles"] {
                // 3
                lifeAvatar = dictionary["lifeAvatar"] as! Int
                lifeEnemy = dictionary["lifeEnemy"] as! Int
                maximumMovesToEnemy = dictionary["movesToEnemy"] as! Int
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
        print(row)
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
    
    private func calculateScores(chains: Set<Chain>) {
        // 3-chain is 60 pts, 4-chain is 120, 5-chain is 180, and so on
        for chain in chains {
            if(chain.skills[0].skillType.spriteName == "Snow"){
                movesToEnemy++
            }else if(chain.skills[0].skillType.spriteName == "Life"){
                if(currentPlayer){
                    self.lifeAvatar = self.lifeAvatar + 18 * (chain.length - 2) * comboMultiplier
                    if(self.lifeAvatar > self.totalLifeAvatar){
                        self.lifeAvatar = self.totalLifeAvatar
                    }
                    ++comboMultiplier
                }else{
                    self.lifeEnemy = self.lifeEnemy + 18 * (chain.length - 2) * comboMultiplier
                    if(self.lifeEnemy > self.totalLifeEnemy){
                        self.lifeEnemy = self.totalLifeEnemy
                    }
                    ++comboMultiplier
                }
            }else{
                //chamar hierarquia
                hierarquiaScores(chain)
                ++comboMultiplier
            }
        }
    }
    
    private func hierarquiaScores(chain: Chain){
        print("tipo da peça: \(chain.skills[0].skillType.hashValue)")
        print("tipo do robô: \(basedRobot.baseType.hashValue)")
        print("tipo do inimigo: \(basedEnemy.baseType.hashValue)")
        if(currentPlayer){
            if(chain.skills[0].skillType.hashValue == basedRobot.baseType.hashValue){
                if((chain.skills[0].skillType.hashValue == 4 && basedEnemy.baseType.hashValue == 1) || chain.skills[0].skillType.hashValue < basedEnemy.baseType.hashValue){
                    chain.score = 150 * (chain.length - 2) * comboMultiplier
                }else{
                    chain.score = 90 * (chain.length - 2) * comboMultiplier
                }
            }else{
                if((chain.skills[0].skillType.hashValue == 4 && basedEnemy.baseType.hashValue == 1) || chain.skills[0].skillType.hashValue < basedEnemy.baseType.hashValue){
                    chain.score = 30 * (chain.length - 2) * comboMultiplier
                }else{
                    chain.score = 18 * (chain.length - 2) * comboMultiplier
                }
            }
        }else{
            if(chain.skills[0].skillType.hashValue == basedEnemy.baseType.hashValue){
                if((chain.skills[0].skillType.hashValue == 4 && basedRobot.baseType.hashValue == 1) || chain.skills[0].skillType.hashValue < basedRobot.baseType.hashValue){
                    chain.score = 150 * (chain.length - 2) * comboMultiplier
                }else{
                    chain.score = 90 * (chain.length - 2) * comboMultiplier
                }
            }else{
                if((chain.skills[0].skillType.hashValue == 4 && basedRobot.baseType.hashValue == 1) || chain.skills[0].skillType.hashValue < basedRobot.baseType.hashValue){
                    chain.score = 30 * (chain.length - 2) * comboMultiplier
                }else{
                    chain.score = 18 * (chain.length - 2) * comboMultiplier
                }
            }
        }
    }
    
    func resetComboMultiplier() {
        comboMultiplier = 1
    }
    
    func animateScoreForChain(chain: Chain) {
        // Figure out what the midpoint of the chain is.
        let firstSprite = chain.firstSkill().sprite!
        let lastSprite = chain.lastSkill().sprite!
        let centerPosition = CGPoint(
            x: (firstSprite.position.x + lastSprite.position.x)/2,
            y: (firstSprite.position.y + lastSprite.position.y)/2 - 8)
        
        // Add a label for the score that slowly floats up.
        let scoreLabel = SKLabelNode(fontNamed: "GillSans-BoldItalic")
        scoreLabel.fontSize = 30
        scoreLabel.text = String(format: "%ld", chain.score)
        scoreLabel.position = centerPosition
        scoreLabel.zPosition = 300
        self.addChild(scoreLabel)
        
        let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: 3), duration: 0.7)
        moveAction.timingMode = .EaseOut
        scoreLabel.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    func isPossibleSwap(swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let skill = skills[column, row] {
                    
                    // Is it possible to swap this skill with the one on the right?
                    if column < NumColumns - 1 {
                        // Have a skill in this spot? If there is no tile, there is no skill.
                        if let other = skills[column + 1, row] {
                            // Swap them
                            skills[column, row] = other
                            skills[column + 1, row] = skill
                            
                            // Is either skill now part of a chain?
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
                            
                            // Is either skill now part of a chain?
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
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        calculateScores(horizontalChains)
        calculateScores(verticalChains)
        
        removeSkills(horizontalChains)
        removeSkills(verticalChains)
        
        return horizontalChains.union(verticalChains)
    }
    
    private func removeSkills(chains: Set<Chain>) {
        for chain in chains {
            for skill in chain.skills {
                skills[skill.column, skill.row] = nil
            }
        }
    }
    
    func animateMatchedSkills(chains: Set<Chain>, completion: () -> ()) {
        for chain in chains {
            animateScoreForChain(chain)
            for skill in chain.skills {
                if let sprite = skill.sprite {
                    if sprite.actionForKey("removing") == nil {
                        let nameType: String = skill.skillType.spriteName
                        var skillTypeSpriteArray = Array<SKTexture>()
                        for(var j = 1; j<5; j++){
                            let nameTexture = nameType + String(j)
                            skillTypeSpriteArray.append(SKTexture(imageNamed: nameTexture))
                        }
                        let changeSprite = SKAction.animateWithTextures(skillTypeSpriteArray, timePerFrame: 0.075)
                        let scaleAction = SKAction.scaleTo(0.1, duration: 0.3)
                        scaleAction.timingMode = .EaseOut
                        print(nameType)
                        matchSound = SKAction.playSoundFileNamed(nameType, waitForCompletion: false)
                        if(self.efectsPermission()){
                            runAction(matchSound)
                        }
                        sprite.runAction(SKAction.sequence([changeSprite ,scaleAction, SKAction.removeFromParent()]),
                            withKey:"removing")
                    }
                }
            }
        }
        //runAction(matchSound)
        runAction(SKAction.waitForDuration(0.3), completion: completion)
    }
    
    private func detectHorizontalMatches() -> Set<Chain> {
        // 1
        var set = Set<Chain>()
        // 2
        for row in 0..<NumRows {
            for var column = 0; column < NumColumns - 2 ; {
                // 3
                if let skill = skills[column, row] {
                    let matchType = skill.skillType
                    // 4
                    if skills[column + 1, row]?.skillType == matchType &&
                        skills[column + 2, row]?.skillType == matchType {
                            // 5
                            let chain = Chain(chainType: .Horizontal)
                            
                            repeat {
                                chain.addSkill(skills[column, row]!)
                                ++column
                            } while column < NumColumns && skills[column, row]?.skillType == matchType
                            
                            set.insert(chain)
                            continue
                    }
                }
                // 6
                ++column
            }
        }
        return set
    }
    
    private func detectVerticalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        
        for column in 0..<NumColumns {
            for var row = 0; row < NumRows - 2; {
                if let skill = skills[column, row] {
                    let matchType = skill.skillType
                    
                    if skills[column, row + 1]?.skillType == matchType &&
                        skills[column, row + 2]?.skillType == matchType {
                            
                            let chain = Chain(chainType: .Vertical)
                            
                            repeat {
                                chain.addSkill(skills[column, row]!)
                                ++row
                            } while row < NumRows && skills[column, row]?.skillType == matchType
                            
                            set.insert(chain)
                            continue
                    }
                }
                ++row
            }
        }
        return set
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
    
    func showSelectionIndicatorForSkill(skill: Skill) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = skill.sprite {
            let texture = SKTexture(imageNamed: skill.skillType.highlightedSpriteName)
            selectionSprite.size = texture.size()
            selectionSprite.runAction(SKAction.setTexture(texture))
            selectionSprite.zPosition = 15
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
        let (success, column, row) = convertPoint(CGPointMake(location.x, location.y + self.offsetTiles))
        if success {
            // 3
            if let skill = self.skillAtColumn(column, row: row) {
                showSelectionIndicatorForSkill(skill)
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
        
        let (success, column, row) = convertPoint(CGPointMake(location.x, location.y + self.offsetTiles))
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
    
    func enemyPlay(){
        //escurecer a tela pra jogada do inimigo
        /*
        let bgBackground = SKSpriteNode(color: UIColor(red: 205/256, green: 205/256, blue: 205/256, alpha: 0.5), size: CGSizeMake(600, 600))
        bgBackground.name = "bgEnemy"
        bgBackground.blendMode = SKBlendMode.Multiply
        bgBackground.position = CGPointMake(301, 301)
        bgBackground.zPosition = 20
        addChild(bgBackground)
        */
        //chamar display
        detectPossibleSwaps()
        let swap : Swap = possibleSwaps.first!
        print(swap.skillA.description)
        print(swap.skillB.description)
        showSelectionIndicatorForSkill(swap.skillA)
        
        swipeFromColumn = swap.skillA.column
        swipeFromRow = swap.skillA.row
        
        var horzDelta = 0, vertDelta = 0
        if swap.skillB.column < swipeFromColumn! {          // swipe left
            horzDelta = -1
        } else if swap.skillB.column > swipeFromColumn! {   // swipe right
            horzDelta = 1
        } else if swap.skillB.row < swipeFromRow! {         // swipe down
            vertDelta = -1
        } else if swap.skillB.row > swipeFromRow! {         // swipe up
            vertDelta = 1
        }
        
        // 4
        if horzDelta != 0 || vertDelta != 0 {
            trySwapHorizontal(horzDelta, vertical: vertDelta)
            hideSelectionIndicator()
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
    
    //tapar buracos
    func fillHoles() -> [[Skill]] {
        var columns = [[Skill]]()
        // 1
        for column in 0..<NumColumns {
            var array = [Skill]()
            for row in 0..<NumRows {
                // 2
                if tiles[column, row] != nil && skills[column, row] == nil {
                    // 3
                    for lookup in (row + 1)..<NumRows {
                        if let skill = skills[column, lookup] {
                            // 4
                            skills[column, lookup] = nil
                            skills[column, row] = skill
                            skill.row = row
                            // 5
                            array.append(skill)
                            // 6
                            break
                        }
                    }
                }
            }
            // 7
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    //animação da queda dos itens
    func animateFallingSkills(columns: [[Skill]], completion: () -> ()) {
        // 1
        var longestDuration: NSTimeInterval = 0
        for array in columns {
            for (idx, skill) in array.enumerate() {
                let newPosition = pointForColumn(skill.column, row: skill.row)
                // 2
                let delay = 0.05 + 0.15*NSTimeInterval(idx)
                // 3
                let sprite = skill.sprite!
                sprite.zPosition = 15
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
                // 4
                longestDuration = max(longestDuration, duration + delay)
                // 5
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        //SKAction.group([moveAction, fallingSkillSound])
                        moveAction]))
            }
        }
        // 6
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
    func topUpSkills() -> [[Skill]] {
        var columns = [[Skill]]()
        var skillType: SkillType = .Unknown
        
        for column in 0..<NumColumns {
            var array = [Skill]()
            // 1
            for var row = NumRows - 1; row >= 0 && skills[column, row] == nil; --row {
                // 2
                if tiles[column, row] != nil {
                    // 3
                    var newSkillType: SkillType
                    repeat {
                        newSkillType = SkillType.random()
                    } while newSkillType == skillType
                    skillType = newSkillType
                    // 4
                    let skill = Skill(column: column, row: row, skillType: skillType)
                    skills[column, row] = skill
                    array.append(skill)
                }
            }
            // 5
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func animateNewSkills(columns: [[Skill]], completion: () -> ()) {
        // 1
        var longestDuration: NSTimeInterval = 0
        
        for array in columns {
            // 2
            let startRow = array[0].row + 1
            
            for (idx, skill) in array.enumerate() {
                // 3
                let sprite = SKSpriteNode(imageNamed: skill.skillType.spriteName)
                sprite.position = pointForColumn(skill.column, row: startRow)
                sprite.zPosition = 15
                self.addChild(sprite)
                skill.sprite = sprite
                // 4
                let delay = 0.1 + 0.2 * NSTimeInterval(array.count - idx - 1)
                // 5
                let duration = NSTimeInterval(startRow - skill.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                // 6
                let newPosition = pointForColumn(skill.column, row: skill.row)
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.alpha = 0
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        SKAction.group([
                            SKAction.fadeInWithDuration(0.05),
                            moveAction//,
                            //addSkillSound
                            ])
                        ]))
            }
        }
        // 7
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
    func animateSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.skillA.sprite!
        let spriteB = swap.skillB.sprite!
        
        spriteA.zPosition = self.zPositionSkillA
        spriteB.zPosition = self.zPositionSkillB
        
        let Duration: NSTimeInterval = 0.3
        
        //runAction(swapSound)
        
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
        
        spriteA.zPosition = self.zPositionSkillA
        spriteB.zPosition = self.zPositionSkillB
        
        let Duration: NSTimeInterval = 0.2
        
        //runAction(invalidSwapSound)
        
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
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2 - self.offsetTiles)
    }
    
}

