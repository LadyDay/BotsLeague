//
//  GameScene.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var level: Level!
    
    let TileWidth: CGFloat = 83.0
    let TileHeight: CGFloat = 85.0
    
    let tilesLayer = SKNode()
    var gameLayer: SKSpriteNode!
    let skillsLayer = SKNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        displayLevel(level)
        
        tilesLayer.position = level.position
        level.addChild(tilesLayer)
        addTiles()
        
        beginGame()
        level.swipeHandler = handleSwipe
    }
    
    func handleSwipe(swap: Swap) {
        self.view!.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            level.animateSwap(swap, completion: {
                self.view!.userInteractionEnabled = true
            })
        } else {
            level.animateInvalidSwap(swap, completion: {
                self.view!.userInteractionEnabled = true
            })
        }
    }
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = level.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.position = pointForColumn(column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func addSpritesForSkills(skills: Set<Skill>) {
        for skill in skills {
            let sprite = SKSpriteNode(imageNamed: skill.skillType.spriteName)
            sprite.position = pointForColumn(skill.column, row:skill.row)
            //skillsLayer.addChild(sprite)
            level.addChild(sprite)
            skill.sprite = sprite
        }
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newSkills = level.shuffle()
        self.addSpritesForSkills(newSkills)
    }
    
    func displayLevel(level: Level){
        let viewLevel = SKView(frame: CGRectMake(67, 319, 631, 633))
        viewLevel.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(viewLevel as UIView)
        viewLevel.presentScene(level)
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
