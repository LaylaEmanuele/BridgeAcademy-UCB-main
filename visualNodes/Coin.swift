//
//  Coin.swift
//  BridgeRunGame
//
//  Created by Victor Brito on 17/06/21.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {

    public func configure() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: kCoinWidthHeight / 2,
                                                        height: kCoinWidthHeight / 2))
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = kIceCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = kPlayerCategory
    }

    public func collected() {
        removeFromParent()
    }

}

