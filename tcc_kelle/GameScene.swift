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
    var currentLevel: Int!
    var gameOverPanel: SKSpriteNode!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    let TileWidth: CGFloat = 86.0
    let TileHeight: CGFloat = 86.0
    
    let tilesLayer = SKNode()
    let skillsLayer = SKNode()
    
    var movesToEnemy = 0
    var score = 0
    
    var basedRobot: Base!
    var basedEnemy: Base!
    
    var lifeAvatarLabel: SKLabelNode!
    var lifeEnemyLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    //var movesLabel: SKLabelNode!
    var currentPlayer: Bool!
    
    let swapSound = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false)
    let invalidSwapSound = SKAction.playSoundFileNamed("Erro.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame")
        
        basedRobot = Base(baseType: BaseType(rawValue: dictionary!["currentBase"] as! Int)!)
        basedRobot.sprite = self.childNodeWithName("myRobot-base") as! SKSpriteNode
        basedRobot.sprite!.texture = SKTexture(imageNamed: basedRobot.baseType.highlightedSpriteName)
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(level.fileName) {
            basedEnemy = Base(baseType: BaseType(rawValue: dictionary["basedEnemy"] as! Int)!)
            basedEnemy.sprite = self.childNodeWithName("robotEnemy-base") as! SKSpriteNode
            basedEnemy.sprite!.texture = SKTexture(imageNamed: basedEnemy.baseType.spriteName)
        }
        
        
        lifeAvatarLabel = self.childNodeWithName("lifeAvatarLabel") as! SKLabelNode
        lifeEnemyLabel = self.childNodeWithName("lifeEnemyLabel") as! SKLabelNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        //movesLabel = self.childNodeWithName("movesLabel") as! SKLabelNode
        
        displayLevel(level)
        
        tilesLayer.position = level.position
        tilesLayer.zPosition = 11
        level.addChild(tilesLayer)
        addTiles()
        
        beginGame()
        level.swipeHandler = handleSwipe
    }
    
    //função chamada quando avatar ganha ou perde
    
    func showGameOver() {
        gameOverPanel = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(768, 1024))
        gameOverPanel.position = CGPointMake(384, 512)
        gameOverPanel.zPosition = 30
        level.view?.removeFromSuperview()
        self.addChild(gameOverPanel)
        level.userInteractionEnabled = false
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
        self.view!.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func hideGameOver() {
        var win: Bool
        if(gameOverPanel.name == "win"){
            win = true
        }else{
            win = false
        }
        
        if(tapGestureRecognizer != nil){
            self.view!.removeGestureRecognizer(tapGestureRecognizer)
        }
        
        tapGestureRecognizer = nil

        level.userInteractionEnabled = true
        
        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
        let gameScene = MapGame(fileNamed: "MapGame")
        gameScene?.first = false
        
        if(win){
            if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                if (dictionary["currentLevel"] as! Int) < self.currentLevel + 1{
                    Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: "currentLevel", object: self.currentLevel + 1)
                }
            }
            gameScene!.currentLevel = self.currentLevel + 1
        }else{
            gameScene!.currentLevel = self.currentLevel
        }
        self.view?.presentScene(gameScene!, transition: fadeScene)
    }
/*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
        let nodeTouched = self.nodeAtPoint(location)
    }
*/    
    //sinaliza situação atual do jogo em pontos
    func updateLabels() {
        lifeAvatarLabel.text = String(format: "%ld", level.lifeAvatar)
        lifeEnemyLabel.text = String(format: "%ld", level.lifeEnemy)
        scoreLabel.text = String(format: "%ld", score)
        //movesLabel.text = String(format: "%ld", movesToEnemy)
    }
    
    //decrementa o número de movimentos até o movimento do adversário
    func decrementMoves() {
        --movesToEnemy
        updateLabels()
        
        //mudar o jogador
        if(movesToEnemy==0){
            movesToEnemy = level.maximumMovesToEnemy
            currentPlayer = !currentPlayer
        }
        
        if(currentPlayer == false){
            //chama a função pro inimigo atacar
            self.view!.userInteractionEnabled = false
            level.zPositionSkillA = 17
            level.zPositionSkillB = 16
            basedRobot.sprite!.texture = SKTexture(imageNamed: basedRobot.baseType.spriteName)
            basedEnemy.sprite!.texture = SKTexture(imageNamed: basedEnemy.baseType.highlightedSpriteName)
            level.enemyPlay()
        }else{
            level.zPositionSkillA = 100
            level.zPositionSkillB = 90
            if(level.bgEnemyPresent){
                let bg = self.level.childNodeWithName("bgEnemy")
                bg?.removeFromParent()
            }
            basedRobot.sprite!.texture = SKTexture(imageNamed: basedRobot.baseType.highlightedSpriteName)
            basedEnemy.sprite!.texture = SKTexture(imageNamed: basedEnemy.baseType.spriteName)
        }
        
        updateLabels()
    }
    
    //verifica se o jogo acabou
    func finishedPlay(){
        if (self.level.lifeEnemy < 1) {
            //gameOverPanel.texture = SKTexture(imageNamed: "")
            showGameOver()
            gameOverPanel.texture = SKTexture(imageNamed: "ganhou")
            gameOverPanel.name = "win"
        } else if (self.level.lifeAvatar < 1){
            //gameOverPanel.texture = SKTexture(imageNamed: "")
            showGameOver()
            gameOverPanel.texture = SKTexture(imageNamed: "perdeu")
            gameOverPanel.name = "lose"
        }
    }
    
    //verifica se o swipe é possivel
    func handleSwipe(swap: Swap) {
        self.view!.userInteractionEnabled = false
        
        runAction(swapSound)
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            level.animateSwap(swap, completion: handleMatches)
        } else {
            level.animateInvalidSwap(swap, completion: {
                self.runAction(self.invalidSwapSound, completion: {
                    if(self.currentPlayer == true){
                        self.view!.userInteractionEnabled = true
                    }
                })
            })
        }
    }
    
    //verifica se há matches
    func handleMatches() {
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        level.animateMatchedSkills(chains) {
            for chain in chains {
                if(self.currentPlayer == true){
                    self.score += chain.score
                    self.level.lifeEnemy -= chain.score
                }else{
                    self.level.lifeAvatar -= chain.score
                }
                
            }
            self.updateLabels()
            let columns = self.level.fillHoles()
            self.level.animateFallingSkills(columns) {
                let columns = self.level.topUpSkills()
                self.level.animateNewSkills(columns) {
                    self.handleMatches()
                }
            }
        }
    }
    
    //começa novo turno
    func beginNextTurn() {
        
        if(level.comboMultiplier > 2){
            let som = "Combo" + String(level.comboMultiplier - 2) + ".mp3"
            runAction(SKAction.playSoundFileNamed(som, waitForCompletion: false))
        }
        
        level.detectPossibleSwaps()
        if level.possibleSwaps.count == 0 {
            
            //chamar função para exibir uma view em cima
            
            let newSkills = level.shuffle()
            removeSpritesForSkills(newSkills)
            shuffle()
        }
        
        level.resetComboMultiplier()
        decrementMoves()
        //verifica se o jogo acabou
        finishedPlay()
        if(self.currentPlayer == true){
            self.view!.userInteractionEnabled = true
        }
    }
    
    //adiciona telhas (quadrados marrons)
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = level.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.position = pointForColumn(column, row: row)
                    tilesLayer.zPosition = 14
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    //adiciona os sprites dos skills na tela
    func addSpritesForSkills(skills: Set<Skill>) {
        for skill in skills {
            let sprite = SKSpriteNode(imageNamed: skill.skillType.spriteName)
            sprite.position = pointForColumn(skill.column, row:skill.row)
            //skillsLayer.addChild(sprite)
            sprite.zPosition = 15
            level.addChild(sprite)
            skill.sprite = sprite
        }
    }
    
    //adiciona os sprites dos skills na tela
    func removeSpritesForSkills(skills: Set<Skill>){
        for skill in skills {
            let sprite = level.nodeAtPoint(pointForColumn(skill.column, row:skill.row))
            sprite.removeFromParent()
        }
    }
    
    //começa novo jogo
    func beginGame() {
        currentPlayer = true
        shuffle()
        level.resetComboMultiplier()
        movesToEnemy = level.maximumMovesToEnemy
        score = 0
        updateLabels()
    }
    
    //gera novo skills
    func shuffle() {
        let newSkills = level.shuffle()
        self.addSpritesForSkills(newSkills)
    }
    
    //cria uma view para o level e apresenta o level nela
    func displayLevel(level: Level){
        
        let levelName = "Level_" + String(currentLevel)
        let bgBackground = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(632, 634))
        bgBackground.position = CGPointMake(384, 340)
        bgBackground.zPosition = 10
        bgBackground.texture = SKTexture(imageNamed: levelName)
        self.addChild(bgBackground)
        let viewLevel = SKView(frame: CGRectMake(83, 379, 602, 602))
        viewLevel.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(viewLevel as UIView)
        viewLevel.presentScene(level)
    }
    
    //usa as variáveis de largura e altura da telha para posiciona-las
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
