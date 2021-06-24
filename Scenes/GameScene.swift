//
//  GameScene.swift
//  SpriteKittDemo
//
//  reated by Victor Brito on 17/06/21.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene, SKPhysicsContactDelegate {

    //allow double jump
    private let kJumps = 2
    private let kCityScrollingVelocity: CGFloat = 40.0 / 4
    private let kMountainsVelocity: CGFloat = 5.0 / 4
    private let kCloudsVelocity: CGFloat = 2.0 / 4
    private let ForestIIIVelocity: CGFloat = 40.0/4
    private let ForestIIVelocity: CGFloat = 5.0/4
    private var playerStartPoint = CGPoint.zero

    private var skyGradient: SKSpriteNode?
    private var player: Player?
    private var ice: SKSpriteNode?
    private var scrollingCityBackground: ScrollingBackground?
    private var scrollingMountainsBackground: ScrollingBackground?
    private var scrollingCloudsBackground: ScrollingBackground?
    private var scrollingForestIII: ScrollingBackground?
    private var scrollingForestII: ScrollingBackground?

    //UI
    private var coinsCounter: CoinsCounter?

    private var platformsGenerator: PlatformsGenerator?
    private var platformsNode: SKSpriteNode?

    private var jumps = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        skyGradient = childNode(withName: "skyGradient") as? SKSpriteNode

        scrollingCloudsBackground = childNode(withName: "scrollingCloudsBackground") as? ScrollingBackground
        if let _ = self.scrollingCloudsBackground {
            
            configureCloudsBackground()
        }

        scrollingMountainsBackground = childNode(withName: "scrollingMountainsBackground") as? ScrollingBackground
        if let _ = self.scrollingMountainsBackground {
            configureMountainsBackground()
        }

        scrollingCityBackground = childNode(withName: "scrollingCityBackground") as? ScrollingBackground
        if let _ = self.scrollingCityBackground {
            configureCityBackground()
            scrollingCityBackground?.setScale(0.40)
        }
        
        scrollingForestIII = childNode(withName: "scrollingForestIIIBackground") as? ScrollingBackground
        if let _ = self.scrollingForestIII {
            //scrollingForestII?.setScale(0.50)
            configureForestIIIBackground()
        }
        
        scrollingForestII = childNode(withName: "scrollingForestIIBackground") as? ScrollingBackground
        if let _ = self.scrollingForestII {
            configureForestIIBackground()
            scrollingForestII?.setScale(0.20)
        }

        
        
        

        player = childNode(withName: "player") as? Player
        if let player = self.player {
            player.physicsBody?.categoryBitMask = kPlayerCategory
            player.physicsBody?.contactTestBitMask = kIceCategory
            player.run()
        }
        playerStartPoint = calculatePlayerStartPoint()

        ice = childNode(withName: "ice") as? SKSpriteNode
        if let ice = self.ice {
            ice.physicsBody?.categoryBitMask = kIceCategory
            ice.physicsBody?.contactTestBitMask = kPlayerCategory
        }

        platformsGenerator = PlatformsGenerator()
        platformsNode = platformsGenerator?.configurePlatformsNode(size: self.size)

        if let platformsNode = self.platformsNode {
            addChild(platformsNode)
            platformsNode.position = self.position
            platformsNode.zPosition = 2
            
        }

        coinsCounter = childNode(withName: "CoinsCounter") as? CoinsCounter
        if let coinsCounter = self.coinsCounter {
            coinsCounter.configure()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        scrollingCityBackground?.update(currentTime: currentTime)
        scrollingMountainsBackground?.update(currentTime: currentTime)
        scrollingCloudsBackground?.update(currentTime: currentTime)

        platformsGenerator?.updatePlatform(velocity: kCityScrollingVelocity)

        checkPlayerPosition()
    }

    //MARK: - Private methods
    
    

    
    private func configureForestIIIBackground() {
        scrollingForestIII?.velocity = ForestIIIVelocity
        scrollingForestIII?.backgroundImagesNames = ["Forest_III_01", "Forest_III_02", "Forest_III_03", "Forest_III_04", "Forest_III_05", "Forest_III_06", "Forest_III_07", "Forest_III_08"]
        scrollingForestIII?.configureScrollingBackground()
    }
    
    private func configureForestIIBackground() {
        scrollingForestII?.velocity = ForestIIVelocity
        scrollingForestII?.backgroundImagesNames = ["Forest_II_01", "Forest_II_02", "Forest_II_03", "Forest_II_04", "Forest_II_05", "Forest_II_06", "Forest_II_07", "Forest_II_08"]
        scrollingForestII?.configureScrollingBackground()
    }
    
    
    
    
    private func configureCityBackground() {
        scrollingCityBackground?.velocity = kCityScrollingVelocity
        scrollingCityBackground?.backgroundImagesNames = ["city01", "city02", "city03", "city04", "city05", "city06", "city07", "city08"]
        scrollingCityBackground?.configureScrollingBackground()
    }

    private func configureMountainsBackground() {
        scrollingMountainsBackground?.velocity = kMountainsVelocity
        scrollingMountainsBackground?.backgroundImagesNames = ["mountains01", "mountains02", "mountains03", "mountains04", "mountains05", "mountains06", "mountains07", "mountains08"]
        scrollingMountainsBackground?.configureScrollingBackground()
    }

    private func configureCloudsBackground() {
        scrollingCloudsBackground?.velocity = kCloudsVelocity
        scrollingCloudsBackground?.backgroundImagesNames = ["clouds01", "clouds02", "clouds03", "clouds04", "clouds05", "clouds06", "clouds07", "clouds08"]
        scrollingCloudsBackground?.configureScrollingBackground()
    }

    private func checkPlayerPosition() {
        guard let player = self.player else { return }

        //Don't allow player to hide on left side
        if player.position.x < -frame.width / 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                player.position = self.playerStartPoint
            })
        }
    }

    private func calculatePlayerStartPoint() -> CGPoint {
        let x = -frame.width / 2 + frame.width/4
        let y = frame.height / 2 + frame.height/4

        return CGPoint(x: x, y: y)
    }

    private func userInteraction() {
        if jumps < kJumps {
            jumps += 1
            player?.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 380)) //impulse vs force?
        }
    }

    //MARK: - SKPhysicsContactDelegate methods

    func didBegin(_ contact: SKPhysicsContact) {
        player?.inAir = false
        player?.run()
        jumps = 0

        //coins
        if contact.bodyB.node is Coin {
            if let coin = contact.bodyB.node as? Coin {
                coinsCounter?.increaseCounter()
                coin.collected()
            }
        }
    }

    
    //MARK: - Touch methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userInteraction()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }



    

}
