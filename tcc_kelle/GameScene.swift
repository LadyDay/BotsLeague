//
//  GameScene.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import SpriteKit

class GameScene: SceneInterface {
    
    var finished: Bool = false

    var level: Level!
    var currentLevel: Int!
    var viewEnd: SKView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    let TileWidth: CGFloat = 86.0
    let TileHeight: CGFloat = 86.0
    
    let tilesLayer = SKNode()
    let skillsLayer = SKNode()
    
    var score = 0
    
    var barraLifeAvatar: SKSpriteNode!
    var barraLifeEnemy: SKSpriteNode!
    
    var piscarBool = false
    
    var lifeAvatarLabel: SKLabelNode!
    var lifeEnemyLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    //var movesLabel: SKLabelNode!
    
    let swapSound = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false)
    let invalidSwapSound = SKAction.playSoundFileNamed("Erro.mp3", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.playSoundBackground("Fase1")
        
        let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame")
        let dictionaryRobot = Dictionary<String, AnyObject>.loadGameData("Robot")
        
        level.basedRobot = Base(baseType: BaseType(rawValue: dictionary!["currentBase"] as! Int)!)
        level.basedRobot.sprite = self.childNodeWithName("myRobot-base") as! SKSpriteNode
        level.basedRobot.sprite!.texture = SKTexture(imageNamed: level.basedRobot.baseType.highlightedSpriteName)
        
        //set texture parts of my robot
        setTexturePartRobot("antenna", dictionary: dictionaryRobot!)
        setTexturePartRobot("head", dictionary: dictionaryRobot!)
        setTexturePartRobot("eyes", dictionary: dictionaryRobot!)
        setTexturePartRobot("body", dictionary: dictionaryRobot!)
        setTexturePartRobot("leftArm", dictionary: dictionaryRobot!)
        setTexturePartRobot("rightArm", dictionary: dictionaryRobot!)
        setTexturePartRobot("legs", dictionary: dictionaryRobot!)
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(level.fileName) {
            level.basedEnemy = Base(baseType: BaseType(rawValue: dictionary["basedEnemy"] as! Int)!)
            level.basedEnemy.sprite = self.childNodeWithName("robotEnemy-base") as! SKSpriteNode
            level.basedEnemy.sprite!.texture = SKTexture(imageNamed: level.basedEnemy.baseType.spriteName)
            
            //ler o offset
            level.offsetTiles = dictionary["offset"] as! CGFloat
        }
        
        lifeAvatarLabel = self.childNodeWithName("lifeAvatarLabel") as! SKLabelNode
        lifeEnemyLabel = self.childNodeWithName("lifeEnemyLabel") as! SKLabelNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        barraLifeAvatar = self.childNodeWithName("lifeMyRobot") as! SKSpriteNode
        barraLifeEnemy = self.childNodeWithName("lifeEnemy") as! SKSpriteNode
        
        level.totalLifeAvatar = level.lifeAvatar
        level.totalLifeEnemy = level.lifeEnemy
        //movesLabel = self.childNodeWithName("movesLabel") as! SKLabelNode
        
        displayLevel(level)
        
        tilesLayer.position = level.position
        tilesLayer.zPosition = 11
        level.addChild(tilesLayer)
        addTiles()
        
        beginGame()
        level.swipeHandler = handleSwipe
    }
    
    func setTexturePartRobot(string: String, dictionary: Dictionary<String, AnyObject>){
        let namePart = "myRobot-" + string
        let spritePart = self.childNodeWithName(namePart) as! SKSpriteNode
        spritePart.texture = SKTexture(imageNamed: dictionary[string] as! String)
    }
    
    //função chamada quando avatar ganha ou perde
    
    func showGameOver(win: Bool) {
        viewEnd = SKView(frame: CGRect(x: 0, y: 0, width: 768, height: 1024))
        viewEnd.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(viewEnd)
        
        self.stopSoundBackground()
        
        let endScene: EndGame!
        
        if(win){
            if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame"){
                if (dictionary["currentLevel"] as! Int) < self.currentLevel + 1{
                    Dictionary<String, AnyObject>.saveGameData("CurrentGame", key: "currentLevel", object: self.currentLevel + 1)
                }
            }
            endScene = EndGame(fileNamed: "GameWin")
            endScene.win = true
        }else{
            endScene = EndGame(fileNamed: "GameLost")
            endScene.win = false
        }
        
        endScene.gamePlay = self
        endScene.currentScore = self.score
        
        self.userInteractionEnabled = false
        level.userInteractionEnabled = false
        
        let fadeScene = SKTransition.crossFadeWithDuration(1.5)
        viewEnd.presentScene(endScene, transition: fadeScene)
        endScene.scaleMode = .AspectFill
    }
    
    func porcentagemLifeSprite(){
        let porcentagemAvatar = Float(level.lifeAvatar) / Float(level.totalLifeAvatar)
        let porcentagemEnemy = Float(level.lifeEnemy) / Float(level.totalLifeEnemy)
        diminuiBarra(barraLifeAvatar, porcentagem: porcentagemAvatar)
        diminuiBarra(barraLifeEnemy, porcentagem: porcentagemEnemy)
    }
    
    func diminuiBarra(barra: SKSpriteNode, porcentagem: Float){
        while(porcentagem < Float(barra.xScale) && barra.xScale>=0){
            barra.xScale = barra.xScale - 0.1
            if(barra.xScale <= 0.15){
                barra.color = UIColor.redColor()
                if(barra.name! == "lifeMyRobot" && piscarBool==false){
                    piscarLife()
                }
            }
        }
    }
    
    func piscarLife(){
        let piscar = SKSpriteNode(imageNamed: "piscar-vermelho")
        piscar.position = CGPoint(x: 384.5, y: 855.5)
        piscar.zPosition = 1
        piscarBool = true
        self.addChild(piscar)
        
        let vaiNaFe = SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.waitForDuration(0.1), SKAction.fadeInWithDuration(0.5), SKAction.waitForDuration(0.1)])
        
        piscar.runAction(SKAction.repeatActionForever(vaiNaFe))
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            let body = self.nodeAtPoint(location) as? SKSpriteNode
            
            if let name: String = body!.name {
                switch name {
                    
                case "buttonPause":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    print("buttonMenu Touched")
                    if(!boolHierarquia){
                        displayPause()
                    }
                    break
                    
                case "hierarquia":
                    if(efectsPermission()){
                        runAction(SKAction.playSoundFileNamed("Click (in game).mp3", waitForCompletion: true))
                    }
                    
                    if(!boolPause){
                        displayHierarquia()
                    }
                    break
                    
                default:
                    print("nn foi dessa vez")
                    
                }
            }
        }
    }
    
    //sinaliza situação atual do jogo em pontos
    func updateLabels() {
        porcentagemLifeSprite()
        lifeAvatarLabel.text = String(format: "%ld", level.lifeAvatar)
        lifeEnemyLabel.text = String(format: "%ld", level.lifeEnemy)
        scoreLabel.text = String(format: "%ld", score)
        
        //movesLabel.text = String(format: "%ld", movesToEnemy)
    }
    
    //decrementa o número de movimentos até o movimento do adversário
    func decrementMoves() {
        --level.movesToEnemy
        updateLabels()
        
        //mudar o jogador
        if(level.movesToEnemy==0){
            level.movesToEnemy = level.maximumMovesToEnemy
            level.currentPlayer = !level.currentPlayer
        }
        
        if(level.currentPlayer == false){
            //chama a função pro inimigo atacar
            self.view!.userInteractionEnabled = false
            level.zPositionSkillA = 17
            level.zPositionSkillB = 16
            level.basedRobot.sprite!.texture = SKTexture(imageNamed: level.basedRobot.baseType.spriteName)
            level.basedEnemy.sprite!.texture = SKTexture(imageNamed: level.basedEnemy.baseType.highlightedSpriteName)
            if(level.firstEnemyPlay){
                level.firstEnemyPlay = false
                displayLayerEnemy()
            }
            level.enemyPlay()
        }else{
            level.firstEnemyPlay = true
            level.zPositionSkillA = 100
            level.zPositionSkillB = 90
            if(level.bgEnemyPresent != nil){
                level.bgEnemyPresent.removeFromSuperview()
                level.bgEnemyPresent = nil
            }
            level.basedRobot.sprite!.texture = SKTexture(imageNamed: level.basedRobot.baseType.highlightedSpriteName)
            level.basedEnemy.sprite!.texture = SKTexture(imageNamed: level.basedEnemy.baseType.spriteName)
        }
        
        updateLabels()
    }
    
    //verifica se o jogo acabou
    func finishedPlay(){
        if (self.level.lifeEnemy < 1) {
            //gameOverPanel.texture = SKTexture(imageNamed: "")
            finished = true
            showGameOver(true)
        } else if (self.level.lifeAvatar < 1){
            //gameOverPanel.texture = SKTexture(imageNamed: "")
            finished = true
            showGameOver(false)
        }
    }
    
    //verifica se o swipe é possivel
    func handleSwipe(swap: Swap) {
        self.view!.userInteractionEnabled = false
        
        if(efectsPermission()){
            runAction(swapSound)
        }
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            level.animateSwap(swap, completion: handleMatches)
        } else {
            level.animateInvalidSwap(swap, completion: {
                if(self.efectsPermission()){
                    self.runAction(self.invalidSwapSound, completion: {
                        if(self.level.currentPlayer == true){
                            self.view!.userInteractionEnabled = true
                        }
                    })
                }else{
                    if(self.level.currentPlayer == true){
                        self.view!.userInteractionEnabled = true
                    }
                }
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
                if(self.level.currentPlayer == true){
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
            if(self.efectsPermission()){
                runAction(SKAction.playSoundFileNamed(som, waitForCompletion: false))
            }
        }
        
        level.detectPossibleSwaps()
        if level.possibleSwaps.count == 0 {
            
            //chamar função para exibir uma view em cima
            
            let newSkills = level.shuffle()
            removeSpritesForSkills(newSkills)
            shuffle()
        }
        
        level.resetComboMultiplier()
        
        //verifica se o jogo acabou
        finishedPlay()
        if(finished == false){
            decrementMoves()
        }
        if(level.currentPlayer == true){
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
        level.currentPlayer = true
        shuffle()
        level.resetComboMultiplier()
        level.movesToEnemy = level.maximumMovesToEnemy
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
    
    func displayLayerEnemy(){
        let levelName = "Enemy-Level_" + String(currentLevel)
        let scene = SKScene(size: CGSizeMake(632, 634))
        let bgBackground = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(632, 634))
        bgBackground.position = CGPointMake(316, 317)
        bgBackground.zPosition = 30
        bgBackground.blendMode = SKBlendMode.Multiply
        bgBackground.texture = SKTexture(imageNamed: levelName)
        scene.addChild(bgBackground)
        let viewLevel = SKView(frame: CGRectMake(68, 367, 632, 634))
        viewLevel.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(viewLevel as UIView)
        level.bgEnemyPresent = viewLevel
        viewLevel.presentScene(scene)
    }
    
    //usa as variáveis de largura e altura da telha para posiciona-las
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2 - level.offsetTiles)
    }
    
    func displayPause(){
        boolPause = true
        self.userInteractionEnabled = false
        //level.userInteractionEnabled = false
        self.viewPause = SKView(frame: CGRectMake(0, 0, 768, 1024))
        self.viewPause.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(self.viewPause as UIView)
        
        let transition = SKTransition.crossFadeWithDuration(2)
        let gameScene = PauseView(fileNamed: "PauseView")!
        gameScene.gameScene = self
        viewPause.presentScene(gameScene, transition: transition)
    }
    
    func displayHierarquia(){
        boolHierarquia = true
        self.userInteractionEnabled = false
        self.viewHierarquia = SKView(frame: CGRectMake(0, 0, 768, 1024))
        self.viewHierarquia.backgroundColor = UIColor.clearColor()
        self.view?.addSubview(self.viewHierarquia as UIView)
        
        let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Down, duration: 5)
        let gameScene = HierarquiaView(fileNamed: "HierarquiaView")!
        gameScene.gameScene = self
        viewHierarquia.presentScene(gameScene, transition: transition)
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
