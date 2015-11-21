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
    
    let TileWidth: CGFloat = 76.0
    let TileHeight: CGFloat = 75.0
    
    let gameLayer = SKNode()
    let skillsLayer = SKNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        displayLevel(level)
        beginGame()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
        }
        */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
