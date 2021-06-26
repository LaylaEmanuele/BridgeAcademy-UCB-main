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
            let runTexture: [SKTexture] = getWindTextures()
            let runAnimation = SKAction.animate(with: runTexture, timePerFrame: 0.1, resize: false, restore: true)
            let foreverRun = SKAction.repeatForever(runAnimation)

            return foreverRun
        }
    }

    public func run() {
        run(Player.runAnimation)
    }
}

func getWindTextures() -> [SKTexture] {
    var textures = [SKTexture]()
    for i in 1...6 {
        
        let texture = SKTexture(imageNamed: "Player_\(i)")
        //Como é uma pixel art este comando abaixo retira o anti-alising
        texture.filteringMode = .nearest
        textures.append(texture)
        
    }
    
    return textures
}
