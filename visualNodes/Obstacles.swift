//
//  Obstacles.swift
//  BridgeRunGame
//
//  Created by Victor Brito on 23/06/21.
//

import Foundation
import SpriteKit

/*class Coin: SKSpriteNode {
 
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
 */

class obstacle: SKSpriteNode {
    private let kObstacleMargin: CGFloat = 0
    
    public func setup(){
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: kObstaclesWidthHeight / 2, height: kObstaclesWidthHeight / 2))
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = kIceCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = kPlayerCategory
    }
    
    public func collected() {
        removeFromParent()

    }
    
    public func configure() {
        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = kIceCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = kPlayerCategory

        generateCoins()
    }
    
    private func generateCoins() {
        var coins = [Coin]()

        let numberOfCoins = Int(self.frame.width / (kObstaclesWidthHeight + kObstacleMargin)) - 1

        if numberOfCoins < 0 {
            return
        }

        for _ in 0...numberOfCoins {
            let coin = Coin(imageNamed: "LifeCoin")
            coin.size = CGSize(width: kCoinWidthHeight, height: kCoinWidthHeight)
            coin.configure()

            coins.append(coin)

            addChild(coin)
        }

        let coinBlock = CGFloat(numberOfCoins) * kObstaclesWidthHeight + kObstacleMargin * (CGFloat(numberOfCoins) - 1) + CGFloat(kObstacleMargin)
        let sideMargin = (frame.width - coinBlock) / 2

        for i in 0...numberOfCoins {
            let coin = coins[i]

            let margin = sideMargin + kObstaclesWidthHeight * CGFloat(i) + kObstacleMargin * CGFloat(i) - frame.width / 2
            coin.position = CGPoint(x: margin, y: kObstaclesWidthHeight / 2 + frame.height / 2)
        }
    }
    
    
  
}
