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
    private let FloorVelocity: CGFloat = 40.0 / 4

    private var skyGradient: SKSpriteNode?
    private var player: Player?
    private var ice: SKSpriteNode?
    private var scrollingCityBackground: ScrollingBackground?
    private var scrollingMountainsBackground: ScrollingBackground?
    private var scrollingCloudsBackground: ScrollingBackground?
    private var scrollingForestIII: ScrollingBackground?
    private var scrollingForestII: ScrollingBackground?
    private var scrollingFloor: ScrollingBackground?

    //UI
    private var coinsCounter: CoinsCounter?

    private var platformsGenerator: PlatformsGenerator?
    private var platformsNode: SKSpriteNode?

    private var jumps = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        //MARK: - Parallax
        skyGradient = childNode(withName: "skyGradient") as? SKSpriteNode //chamada do bg

        scrollFloor() // floor
        
        scrollLeft(nameImage: "Arvore_III", plano: -2, velocity: 100) // Parallax da arvore III verde escura
        

        scrollingCloudsBackground = childNode(withName: "scrollingCloudsBackground") as? ScrollingBackground
                if let _ = self.scrollingCloudsBackground {
                    
                    configureArvoreIBackground()
                }

                scrollingMountainsBackground = childNode(withName: "scrollingMountainsBackground") as? ScrollingBackground
                if let _ = self.scrollingMountainsBackground {
                    configureArvoreIIBackground()
                }
                
                scrollingCityBackground = childNode(withName: "scrollingCityBackground") as? ScrollingBackground
                if let _ = self.scrollingCityBackground {
                    configureArbustoIIBackground()
                    scrollingCityBackground?.setScale(0.41)
                }
                
               
                
                scrollingCityBackground = childNode(withName: "scrollingForestIIBackground") as? ScrollingBackground
                if let _ = self.scrollingCityBackground { // arbusto
                    configureArbustoIBackground()
                    scrollingCityBackground?.setScale(0.20)

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
            
            
            private func configureArbustoIBackground() {
                scrollingCityBackground?.velocity = kCityScrollingVelocity
                scrollingCityBackground?.backgroundImagesNames = ["Arbusto_I_1", "Arbusto_I_2", "Arbusto_I_3", "Arbusto_I_4", "Arbusto_I_5", "Arbusto_I_6", "Arbusto_I_7", "Arbusto_I_8"]
                scrollingCityBackground?.configureScrollingBackground()
            }
            
            private func configureArvoreIIIBackground() {
                scrollingCityBackground?.velocity = kCityScrollingVelocity
                scrollingCityBackground?.backgroundImagesNames = ["Arvore_III_1", "Arvore_III_2", "Arvore_III_3", "Arvore_III_4", "Arvore_III_5", "Arvore_III_6", "Arvore_III_7", "Arvore_III_8"]
                scrollingCityBackground?.configureScrollingBackground()
            }
            
            
            private func configureArbustoIIBackground() {
                scrollingCityBackground?.velocity = kMountainsVelocity
                scrollingCityBackground?.backgroundImagesNames = ["Arbusto_II_1", "Arbusto_II_2", "Arbusto_II_3", "Arbusto_II_4", "Arbusto_II_5", "Arbusto_II_6", "Arbusto_II_7", "Arbusto_II_8"]
                scrollingCityBackground?.configureScrollingBackground()
            }

            private func configureArvoreIIBackground() {
                scrollingMountainsBackground?.velocity = kMountainsVelocity
                scrollingMountainsBackground?.backgroundImagesNames = ["Arvore_II_1", "Arvore_II_2", "Arvore_II_3", "Arvore_II_4", "Arvore_II_5", "Arvore_II_6", "Arvore_II_7", "Arvore_II_8"]
                scrollingMountainsBackground?.configureScrollingBackground()
            }

            private func configureArvoreIBackground() {
                scrollingCloudsBackground?.velocity = kCloudsVelocity
                scrollingCloudsBackground?.backgroundImagesNames = ["Arvore_I_1", "Arvore_I_2", "Arvore_I_3", "Arvore_I_4", "Arvore_I_5", "Arvore_I_6", "Arvore_I_7", "Arvore_I_8"]
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
    
    
    
    
    
    private func scrollFloor(){
        var parallaxFloor = SKSpriteNode()
        
        let movF = SKAction.move(by: CGVector(dx: -frame.width, dy: 0), duration: TimeInterval(frame.width/1000)) // sentido do movimento o tempo
        
        let resetF = SKAction.move(by: CGVector(dx: 2532, dy: 0), duration:0) //resetar a imagem pro lugar dela
        
        let repF = SKAction.repeatForever(SKAction.sequence([movF, resetF])) //array com as duas posiçoes da img
        var i: CGFloat = 0
        
        while i<2{
            parallaxFloor = SKSpriteNode(imageNamed: "FloorFinal")
            parallaxFloor.position = CGPoint(x: 0.244, y: -456.902)
            //            parallaxFloor.size.width = frame.width
            //            parallaxFloor.size.height = frame.height
            parallaxFloor.zPosition = 0 //profundidade do plano
            parallaxFloor.run(repF)
            addChild(parallaxFloor)
            
            i+=1
        }
        
    }
    
    private func scrollLeft(nameImage: String, plano: Double, velocity: Double){
        var parallaxArvore = SKSpriteNode()
        
        let movFA = SKAction.move(by: CGVector(dx: -frame.width, dy: 0), duration: TimeInterval(frame.width/CGFloat(velocity))) // sentido do movimento o tempo
        
        let resetFA = SKAction.move(by: CGVector(dx: 2532, dy: 0), duration:0) //resetar a imagem pro lugar dela
        
        let repFA = SKAction.repeatForever(SKAction.sequence([movFA, resetFA])) //array com as duas posiçoes da img
        var j: CGFloat = 0
        
        while j<2{
            parallaxArvore = SKSpriteNode(imageNamed: nameImage)
            parallaxArvore.position = CGPoint(x: 0, y: 0)
            //            parallaxFloor.size.width = frame.width
            //            parallaxFloor.size.height = frame.height
            parallaxArvore.zPosition = CGFloat(plano) //profundidade do plano
            parallaxArvore.run(repFA)
            addChild(parallaxArvore)
            
            j+=1
        }
    }
    
    private func scrollRight(nameImage: String, plano: Double, velocity: Double){
        var parallaxArvore = SKSpriteNode()
        
        let movFA = SKAction.move(by: CGVector(dx: frame.width, dy: 0), duration: TimeInterval(frame.width/CGFloat(velocity))) // sentido do movimento o tempo
        
        let resetFA = SKAction.move(by: CGVector(dx: -2532, dy: 0), duration:0) //resetar a imagem pro lugar dela
        
        let repFA = SKAction.repeatForever(SKAction.sequence([movFA, resetFA])) //array com as duas posiçoes da img
        var j: CGFloat = 0
        
        while j<2{
            parallaxArvore = SKSpriteNode(imageNamed: nameImage)
            parallaxArvore.position = CGPoint(x: 0, y: 0)
            //            parallaxFloor.size.width = frame.width
            //            parallaxFloor.size.height = frame.height
            parallaxArvore.zPosition = CGFloat(plano) //profundidade do plano
            parallaxArvore.run(repFA)
            addChild(parallaxArvore)
            
            j+=1
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
