//
//  ShooterScene.swift
//  theNewBostonGame
//
//  Created by Marcos Texeira on 5/3/16.
//  Copyright © 2016 Marcos Texeira. All rights reserved.
//

//import UIKit
import SpriteKit

struct PhysicsCategory {
    static let ryuNode      : UInt32 = 0x1 << 1
    static let evilRyu      : UInt32 = 0x1 << 2
    static let hadukenNode  : UInt32 = 0x1 << 3
}


class ShooterScene: SKScene , SKPhysicsContactDelegate {

    var enemyCount    = 10
    var score         = 0
    var enemies       = SKNode()
    var moveAndRemove = SKAction()
    var animationRyu  = [SKTexture]()
    var ryuNode       = SKNode()
    var hadukenNode   = SKSpriteNode()
    var evilRyu       = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        self.initScene()
    }
    
    func initScene(){
        
        let shooterAtlas = SKTextureAtlas(named : "ryu")
        self.physicsWorld.contactDelegate = self
        
        
        for index in 0...shooterAtlas.textureNames.count-1{
            let imageName = String(format: "haduken%01d",  index)
            
            animationRyu += [shooterAtlas.textureNamed(imageName) ]
        }
        
        let spawn = SKAction.runBlock({
            () in
            
            self.createEvilRyu()
        })
        
        let interval = SKAction.waitForDuration(2.0)
        let spawDelay = SKAction.sequence([spawn,interval])
        
        let spawDelayForever = SKAction.repeatActionForever(spawDelay)
        self.runAction(spawDelayForever)
        
        let distance = CGFloat(self.frame.width + enemies.frame.width + 60)
        // moving the pipes
        let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.009 * distance))
        let removePipes = SKAction.removeFromParent()
        
        moveAndRemove = SKAction.sequence([movePipes, removePipes])
        
    }
    
    
    /// Threating the colisions
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.hadukenNode && secondBody.categoryBitMask == PhysicsCategory.evilRyu || firstBody.categoryBitMask == PhysicsCategory.evilRyu && secondBody.categoryBitMask == PhysicsCategory.hadukenNode {
            score = score + 1
            
            //self.removeChildrenInArray([firstBody.node!])
            firstBody.node?.removeFromParent()
            
            
        }
    }
    
    
    // Animating ..
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /// ...
        ryuNode = self.childNodeWithName("ryuNode")!
        ryuNode.zPosition = 1
        
        if !ryuNode.isEqualToNode(SKNode()){
            let animation = SKAction.animateWithTextures(animationRyu, timePerFrame: 0.15)
            
            /// Animation the HADUUUUUUUUUUKEN!
            let shootHaduken = SKAction.runBlock({
                let hadukenNode = self.createHadukenNode()
                self.addChild(hadukenNode)
                hadukenNode.physicsBody?.applyImpulse(CGVectorMake(190, 0))
                
            })
            
            let sequence = SKAction.sequence([animation, shootHaduken])
            
            ryuNode.runAction(sequence)
        }
    }
    
    // Creating the bullet node
    
    func createHadukenNode() -> SKSpriteNode {
        let ryuNode     = self.childNodeWithName("ryuNode")
        let ryuPosition = ryuNode?.position
        let ryuWidth    = ryuNode?.frame.size.width
        
        hadukenNode = SKSpriteNode(imageNamed: "hadukken.jpg")
        hadukenNode.position = CGPointMake(ryuPosition!.x + ryuWidth!/3, ryuPosition!.y)
        hadukenNode.name = "hadukenNode"
        hadukenNode.size.height = 40
        hadukenNode.size.width = 60
        hadukenNode.physicsBody = SKPhysicsBody(rectangleOfSize: hadukenNode.frame.size)
        //  is a number defining the type of object this is for considering collisions
        hadukenNode.physicsBody?.categoryBitMask = PhysicsCategory.hadukenNode
        // is a number defining what categories of object this node should collide with
        hadukenNode.physicsBody?.collisionBitMask = PhysicsCategory.evilRyu
        // is a number defining which collisions we want to be notified about
        hadukenNode.physicsBody?.contactTestBitMask = PhysicsCategory.evilRyu
        hadukenNode.physicsBody?.dynamic = true
        hadukenNode.physicsBody?.affectedByGravity = true
        hadukenNode.physicsBody?.usesPreciseCollisionDetection = true
        hadukenNode.zPosition = 2
        
        return hadukenNode
    }
    
    func randomBetweenNumbers(min_: CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(min_ - max) + min(min_, max)
    }
    
    func createEvilRyu() {
        enemies = SKNode()
        enemies.name = "enemies"
        
        evilRyu = SKSpriteNode(imageNamed: "evil1.png")
        evilRyu.size.height = 195
        evilRyu.size.width = 119
        
        evilRyu.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
        // physics options
        evilRyu.physicsBody = SKPhysicsBody(rectangleOfSize: evilRyu.size)
        //  is a number defining the type of object this is for considering collisions
        evilRyu.physicsBody?.categoryBitMask = PhysicsCategory.evilRyu
        // is a number defining what categories of object this node should collide with
        evilRyu.physicsBody?.collisionBitMask = PhysicsCategory.hadukenNode
        // is a number defining which collisions we want to be notified about
        evilRyu.physicsBody?.contactTestBitMask = PhysicsCategory.hadukenNode

        evilRyu.physicsBody?.dynamic = false
        evilRyu.physicsBody?.affectedByGravity = false
        
        enemies.addChild(evilRyu)
        enemies.position.y = -290
        enemies.position.x = -86
        
        
        enemies.zPosition = 3
        enemies.runAction(moveAndRemove)
        
        self.addChild(enemies)
        
        
    }

    
}
