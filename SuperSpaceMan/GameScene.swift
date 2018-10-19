//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Apress. All rights reserved.
//

import SpriteKit
import CoreMotion //To use the accelerometer in your game, you first need to add the CoreMotion framework to your GameScene.

class GameScene: SKScene { //extends SKScene and implements two init() methods
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //SKSpriteNode is a node that is used to draw textured sprites
    let foregroundNode = SKSpriteNode() //This node will hold all the sprites that will affect game play.
    let playerNode = SKSpriteNode(imageNamed: "Player")
    var impulseCount = 4
    
    let coreMotionManager = CMMotionManager() //will hold an instance to the CMMotionManager object that will be used to monitor horizontal movement.
    let CollisionCategoryPlayer  : UInt32 = 0x1 << 1 //each of which is an unsigned 32-bit integer.
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2 //This is important to note because collision bit masks are 32 bits, and you can have only 32 unique categories.
    
    required init?(coder aDecoder: NSCoder) {  //takes an NSCoder can be ignored.
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) { //takes a CGSize parameter that represents the size you want the scene to be from GameViewController.
        super.init(size: size)
        physicsWorld.contactDelegate = self //to make the GameScene the delegate of the scene’s physicsWorld.contactD elegate.
        physicsWorld.gravity = CGVector(dx: 0.0, dy:  -5.0); //Changing the vector that represents gravity’s force from Chapter 3 (0.0, –2.0) to (0.0, –5.0).
        isUserInteractionEnabled = true
        
        //add the background
        backgroundNode.size.width = frame.size.width //to size the width of the view's frame
        backgroundNode.anchorPoint = CGPoint(x:0.5,y:0.0) //determine where the new node will be anchored in the scene
        backgroundNode.position = CGPoint(x:size.width / 2.0, y:0.0) //set the position of the backgroundNode
        addChild(backgroundNode) //the snippet adds the backgroundNode to the scene
        addChild(foregroundNode) //add the foregroundNode instance to the scene
        
        //add the player
        playerNode.physicsBody?.allowsRotation = false //preventing from rotation
        playerNode.physicsBody =  SKPhysicsBody(circleOfRadius: playerNode.size.width / 2) //Creates an SKPhysicsBody passing the initializer a parameter named circleOfRadius with a CGFloat for the value. The width of the playerNode divided by 2.
        playerNode.physicsBody?.isDynamic = false //the player doesn’t fall off the screen if you don’t tap the screen in time.
        
        playerNode.position = CGPoint(x:size.width / 2.0, y:180.0) //the snippet is setting the position of the playerNode and adding it to the scene. We change it from 80.0 (Chapter 3) to y:180.0.
        playerNode.physicsBody?.linearDamping = 1.0 //linearDamping has a default of 0.1, is used to reduce a physics body’s linear velocity to simulate fluid or air friction. In this case, you are simulating air friction.
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer //associates the playerNode.physicsBody’s category bit mask to the CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //tells SpriteKit that whenever your physics body comes into contact with another physics body belonging to the category CollisionCategoryPowerUpOrbs, you want to be notified.
        playerNode.physicsBody?.collisionBitMask = 0 //tells SpriteKit not to handle collisions for you.
        foregroundNode.addChild(playerNode) //added to the new foregroundNode
        
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100) //The first line of orbs, a collection of 20, will be centered and will start 100 points above the playNode
        for _ in 0...19 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140 //140 points in between each node’s anchorPoint.
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            foregroundNode.addChild(orbNode)
        }
        
        orbNodePosition = CGPoint(x: playerNode.position.x + 50, y: orbNodePosition.y) //they will be 50 points to the right of the player.
        for _ in 0...19 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140 //140 points in between each node’s anchorPoint.
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            foregroundNode.addChild(orbNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //to turns on user interaction in the scene immediately. This line applies an impulse to the playerNode’s physics body every time you tap the screen.
        
        if !playerNode.physicsBody!.isDynamic {
            playerNode.physicsBody?.isDynamic = true //turning the player’s dynamic volume back on, if it was off, so the player will start reacting to gravity again.
            coreMotionManager.accelerometerUpdateInterval = 0.3 // the interval, in seconds, that the accelerometer will use to update the app with the current acceleration. This value is set to 3/10ths of a second, which provides a pretty smooth update rate.
            coreMotionManager.startAccelerometerUpdates() //starts the accelerometer updates.
        }
        
        if impulseCount > 0 { //If it is greater than 0, then it applies an impulse to the player and
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0,dy:  40.0)) //In this case, you’re creating a vector with an x-value of 0.0 (because you want to apply the impulse only linearly along the y-axis) and a y-value of 40.0, which results in a pulse that springs the player in the opposite direction of gravity.
            impulseCount -= 1 //decrements the impulseCount property by 1.
        }
    }
    
    override func update(_ currentTime: TimeInterval) { //changes the position of the background node based on the current position of the player.
        if playerNode.position.y >= 180.0 {
            backgroundNode.position =
                CGPoint(x: backgroundNode.position.x,
                        y: -((playerNode.position.y - 180.0)/8)) //it sets the position of the backgroundNode to its same x-value but uses a y-value that is 180 points below the position of the player, which is then divided by 8.
            foregroundNode.position = //the foreground is moved at exactly the same rate as the player.
                CGPoint(x: foregroundNode.position.x,
                        y: -(playerNode.position.y - 180.0)) //Moving the foreground at the same rate as the player prevents the player from going too high and leaving the scene.
        }
    }
    
    override func didSimulatePhysics() { //physics changes should be evaluated before the player’s velocity on the x-axis is modified
        if let accelerometerData = coreMotionManager.accelerometerData {
            playerNode.physicsBody!.velocity =
                CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0), //creating a new vector with the most recent accelerometer x-acceleration value multiplied by 380.0 as the x-value, then using the player’s current velocity along the y-axis, and f
                    dy: playerNode.physicsBody!.velocity.dy) //inally making this the player’s new overall velocity.
        }
        if playerNode.position.x < -(playerNode.size.width / 2) { //divided by two
            playerNode.position =
                CGPoint(x: size.width - playerNode.size.width / 2, //divided by two
                    y: playerNode.position.y);
        }
        else if playerNode.position.x > self.size.width {
            playerNode.position = CGPoint(x: playerNode.size.width / 2, //divided by two
                y: playerNode.position.y);
        }
    }
    
    deinit {
        coreMotionManager.stopAccelerometerUpdates() //turning off accelerometer updates when the GameScene is no longer used.
    }
}

extension GameScene: SKPhysicsContactDelegate { //the orb to be removed from the scene as soon as the playerNode contacts the orb.
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node //the node being contacted by the player.
        if nodeB?.name == "POWER_UP_ORB" { //SKNode has a name property equal to POWER_UP_ORB
            impulseCount += 1 //giving the player additional impulses.
            nodeB?.removeFromParent() //if it does, remove the node from the scene.
        }
    }
}
