//
//  GameViewController.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 10/10/15.
//  Copyright (c) 2015 LadyDay. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var level: Level!
    var skView: SKView?
    var location: CGPoint = CGPoint(x: 500, y: 300)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let dictionary = Dictionary<String, AnyObject>.loadGameData("CurrentGame") {
            if((dictionary["currentBase"] as! Int)==0){
                if let scene = Tutorial(fileNamed:"Tutorial") {
                    // Configure the view.
                    let skView = self.view as! SKView
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    skView.presentScene(scene)
                }
            }else{
                if let scene = Home(fileNamed:"Home") {
                    // Configure the view.
                    let skView = self.view as! SKView
                    skView.showsFPS = true
                    skView.showsNodeCount = true
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    skView.presentScene(scene)
                }
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
