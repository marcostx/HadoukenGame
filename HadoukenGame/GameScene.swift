//
//  GameScene.swift
//  theNewBostonGame
//
//  Created by Marcos Texeira on 5/3/16.
//  Copyright (c) 2016 Marcos Texeira. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        let introLabel = childNodeWithName("introLabel")
        
        if (introLabel != nil) {
            let fadeOut = SKAction.fadeOutWithDuration(1.5)
            
            introLabel?.runAction(fadeOut, completion: {
                let doors = SKTransition.doorwayWithDuration(1.5)
                let shooterScene = ShooterScene(fileNamed: "ShooterScene")
                
                self.view?.presentScene(shooterScene!, transition: doors)
                
            })
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
