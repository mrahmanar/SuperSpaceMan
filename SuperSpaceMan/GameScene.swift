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
    let orbNode = SKSpriteNode(imageNamed: "PowerUp") //add the orb sprite to the GameScene at a position
    
    let CollisionCategoryPlayer  : UInt32 = 0x1 << 1 //each of which is an unsigned 32-bit integer.
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2 //This is important to note because collision bit masks are 32 bits, and you can have only 32 unique categories.
    
    required init?(coder aDecoder: NSCoder) {  //takes an NSCoder can be ignored.
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) { //takes a CGSize parameter that represents the size you want the scene to be from GameViewController.
        super.init(size: size)
        physicsWorld.contactDelegate = self //to make the GameScene the delegate of the scene’s physicsWorld.contactD elegate.
        physicsWorld.gravity = CGVector(dx: 0.0, dy:  -0.2); //To slow things down, you need to play around with the game world’s gravity settings. A value of 0.0 for the x-coordinate and a value of –0.2 for the y-coordinate. Though setting the y-coordinate to –0.2 helps us see the playerNode fall off the scene more conducive to game play rather than -0.1.
        isUserInteractionEnabled = true
        
        //add the background
        backgroundNode.size.width = frame.size.width //to size the width of the view's frame
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0) //determine where the new node will be anchored in the scene
        backgroundNode.position = CGPoint(x:size.width / 2.0, y:0.0) //set the position of the backgroundNode
        addChild(backgroundNode) //the snippet adds the backgroundNode to the scene
        
        //add the player
        playerNode.physicsBody?.allowsRotation = false //preventing from rotation
        playerNode.physicsBody =  SKPhysicsBody(circleOfRadius: playerNode.size.width / 2) //Creates an SKPhysicsBody passing the initializer a parameter named circleOfRadius with a CGFloat for the value. The width of the playerNode divided by 2.
        playerNode.physicsBody?.isDynamic = true //to turns the playerNode into a physics body with a dynamic volume. It will now respond to gravity and other physical bodies in the scene.
        
        playerNode.position = CGPoint(x:size.width / 2.0, y:80.0) //the snippet is setting the position of the playerNode and adding it to the scene
        playerNode.physicsBody?.linearDamping = 1.0 //linearDamping has a default of 0.1, is used to reduce a physics body’s linear velocity to simulate fluid or air friction. In this case, you are simulating air friction.
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer //associates the playerNode.physicsBody’s category bit mask to the CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //tells SpriteKit that whenever your physics body comes into contact with another physics body belonging to the category CollisionCategoryPowerUpOrbs, you want to be notified.
        playerNode.physicsBody?.collisionBitMask = 0 //tells SpriteKit not to handle collisions for you.
        addChild(playerNode)
        
        orbNode.position = CGPoint(x: 150.0, y: size.height - 25) //the orbNode is being positioned 25 points from the top of the scene and a little to the left of the player.
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
        orbNode.physicsBody?.isDynamic = false //The playerNode will pass through the scene collecting power-up orbs to fuel its ascent
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs //associates the orbNode’s physics body to the category CollisionCategoryPowerUpOrbs.
        orbNode.physicsBody?.collisionBitMask = 0 //set to 0 because you’re going to handle collisions yourself.
        orbNode.name = "POWER_UP_ORB" //SKNodes have a name property that is used to identify a single node or group of nodes, so you need to use this property to tell you that the player runs into an orb.
        
        addChild(orbNode)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //to turns on user interaction in the scene immediately. This line applies an impulse to the playerNode’s physics body every time you tap the screen.
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0,dy:  40.0)) //In this case, you’re creating a vector with an x-value of 0.0 (because you want to apply the impulse only linearly along the y-axis) and a y-value of 40.0, which results in a pulse that springs the player in the opposite direction of gravity.
        
    }
}

extension GameScene: SKPhysicsContactDelegate { //the orb to be removed from the scene as soon as the playerNode contacts the orb.
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node //the node being contacted by the player.
        if nodeB?.name == "POWER_UP_ORB" { //SKNode has a name property equal to POWER_UP_ORB
            nodeB?.removeFromParent() //if it does, remove the node from the scene.
        }
    }
}
