//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Apress. All rights reserved.
//

import SpriteKit

class GameScene: SKScene { //extends SKScene and implements two init() methods
  
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //SKSpriteNode is a node that is used to draw textured sprites
    let playerNode = SKSpriteNode(imageNamed: "Player")
    
    required init?(coder aDecoder: NSCoder) {  //takes an NSCoder can be ignored.
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) { //takes a CGSize parameter that represents the size you want the scene to be from GameViewController.
        super.init(size: size)
        backgroundNode.size.width = frame.size.width //to size the width of the view's frame
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0) //determine where the new node will be anchored in the scene
        backgroundNode.position = CGPoint(x:size.width / 2.0, y:0.0) //set the position of the backgroundNode
        addChild(backgroundNode) //the snippet adds the backgroundNode to the scene
        
        playerNode.position = CGPoint(x:size.width / 2.0, y:80.0) //the snippet is setting the position of the playerNode and adding it to the scene
        addChild(playerNode)
    }
}
