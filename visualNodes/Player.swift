//
//  Player.swift
//  BridgeRunGame
//
//  Created by Victor Brito on 17/06/21.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode, SKPhysicsContactDelegate {

    public var inAir = false

    private let zeroFloat = CGFloat(0.0)

    private static var runAnimation: SKAction {
        get {
            let run1 = SKTexture(imageNamed: "sapo_idle_1")
            let run2 = SKTexture(imageNamed: "sapo_idle_2")
            let run3 = SKTexture(imageNamed: "sapo_idle_3")
            let run4 = SKTexture(imageNamed: "sapo_idle_4")
            let run5 = SKTexture(imageNamed: "sapo_idle_5")
            let run6 = SKTexture(imageNamed: "sapo_idle_6")

            


            let runTexture = [run1, run2, run3, run4, run5, run6]
            let runAnimation = SKAction.animate(with: runTexture, timePerFrame: 0.1, resize: false, restore: true)
            let foreverRun = SKAction.repeatForever(runAnimation)

            return foreverRun
        }
    }




    public func run() {
        run(Player.runAnimation)
    }



}
