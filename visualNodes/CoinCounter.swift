//
//  CoinCounter.swift
//  BridgeRunGame
//
//  Created by Victor Brito on 17/06/21.
//

import Foundation
import SpriteKit

class CoinsCounter: SKSpriteNode {

    private let kUIHeightMargin: CGFloat = 50.0

    private var label: SKLabelNode?
    private var numberOfCoins = 0

    public func configure() {
      //  position = CGPoint(x: position.x,
          //                 y: UIScreen.main.bounds.width / 5 - kUIHeightMargin)
        configureLabel()
    }

    public func increaseCounter() {
        numberOfCoins += 1
        label?.text = "\(numberOfCoins)"
    }

    private func configureLabel() {
        label = childNode(withName: "coinsLabel") as? SKLabelNode
        

        if let label = self.label {
            label.fontColor = UIColor.coinsTextColor()
            label.text = "\(numberOfCoins)"
            
        }
    }

}
