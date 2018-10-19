//
//  GameViewController.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Apress. All rights reserved.
//

import SpriteKit   //this line makes all the SpriteKit-related classes available to your GameViewController

class GameViewController: UIViewController { //GameViewController extends a UIViewController
    
    var scene: GameScene! //GameScene is the class that will be doing most of your work by adding the game logic. An exclamation point (!) it's an optional, it will follows it's declaration
    
    override var prefersStatusBarHidden: Bool {
        
        return true //a status bar will not displayed in the game
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Configure the main view
        let skView = view as! SKView
        skView.showsFPS = true   //SKView is used to show or hide the frames per second the application is rendering. The higher, the better.
        
        // 2. Create and configure our game scene
        scene = GameScene(size: skView.bounds.size)  //create new instance of the GameScene initializing the size to match the size of the view that will host the scene.
        
        scene.scaleMode = .aspectFill   //Scale mode is used to determine how the scene will be scaled to match the view that will contain it. The aspectFill mode will scale the scene to fill the hosting SKView while maintaining the aspect ratio of the scene, but there may be some cropping if the hosting SKView's aspect ratio is different.
        
        // 3. Show the scene.
        skView.presentScene(scene)
    }
}
