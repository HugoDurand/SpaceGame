import SpriteKit
import CoreMotion
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var starship:StarShip!
    var explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    var backgroundGradient: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var gameTimer: Timer!
    var vilains = ["vilain", "vilain2", "vilain3"]
    let vilainCategory:UInt32 = 0x1 << 1
    let photonMissileCategory:UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var livesArray:[SKSpriteNode]!
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addLives()
        
        /// BACKGROUND
        backgroundGradient = SKSpriteNode(imageNamed: "background.png")
        addChild(backgroundGradient)
        backgroundGradient.zPosition = -2
        
        
        /// STARFIELD
        starfield = SKEmitterNode(fileNamed: "StarField")
        starfield.position = CGPoint(x:0 ,y: self.frame.height / 2)
        starfield.advanceSimulationTime(20)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        
        /// STARSHIP
        starship = StarShip(
            fileName: "millenium-falcon"
        )
        starship.position = CGPoint(x: 0 ,y: -(self.frame.height / 2) + starship.size.height)
        self.addChild(starship)
        starship.zPosition = +2
        
        ///PHYSIC AND CONTACT
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        
        ///SCORE
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: (self.frame.width / 2) - 100, y: (self.frame.height / 2) - 70)
        scoreLabel.fontSize = 24
        score = 0
        self.addChild(scoreLabel)
        
        ///TIMER, INTERVAL BETWEEN VILAIN
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector:#selector(createVilain), userInfo: nil, repeats: true)
        
        
        ///ACCELEROMETRE
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
    }
    
    func addLives(){
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "mini-falcon")
            liveNode.position = CGPoint(x: liveNode.size.width - CGFloat(7 - live) * liveNode.size.width, y: (self.frame.height / 2) - 65)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    @objc func createVilain (){
        vilains = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: vilains) as! [String]
        let vilain = SKSpriteNode(imageNamed: vilains[0])
        
        let randomPosition = GKRandomDistribution(
            lowestValue: Int((-self.frame.size.width / 2) + vilain.size.width * 2),
            highestValue: Int((self.frame.size.width / 2) - vilain.size.width * 2)
        )
        
        let position = CGFloat(randomPosition.nextInt())
        
        vilain.position = CGPoint(x: position, y: self.frame.height / 2 + vilain.size.height)
        vilain.physicsBody = SKPhysicsBody(rectangleOf: vilain.size)
        vilain.physicsBody?.isDynamic = true
        
        vilain.physicsBody?.categoryBitMask = vilainCategory
        vilain.physicsBody?.contactTestBitMask = photonMissileCategory
        vilain.physicsBody?.contactTestBitMask = 0
        
        self.addChild(vilain)
        
        let animationDuration:TimeInterval = 5
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -self.frame.height / 2), duration: animationDuration))
        
        actionArray.append(SKAction.run {
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            if self.livesArray.count > 0 {
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                self.livesArray.removeFirst()
                
                if self.livesArray.count == 0 {
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let gameOverScene = GameOverScene(fileNamed: "GameOverScene")!
                    gameOverScene.scoreValue = String(self.score)
                    self.view?.presentScene(gameOverScene, transition: transition)
                }
            }
        })
        
        actionArray.append(SKAction.removeFromParent())
        
        vilain.run(SKAction.sequence(actionArray))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        starship.fireMissile(scene: self, photonMissileCategory: photonMissileCategory, vilainCategory: vilainCategory)
        }
        
        
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonMissileCategory) != 0 && (secondBody.categoryBitMask & vilainCategory) != 0 {
           missileDidHitVilain(missileNode: firstBody.node as! SKSpriteNode, vilainNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func missileDidHitVilain (missileNode:SKSpriteNode, vilainNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = vilainNode.position
        self.addChild(explosion)
        
        self.run(explosionSound)
        
        missileNode.removeFromParent()
        vilainNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 1
        
        
    }
    
    override func didSimulatePhysics() {
        
        starship.position.x += xAcceleration * 30
        
        if starship.position.x < -self.size.width/2 {
            starship.position = CGPoint(x: self.size.width/2, y: starship.position.y)
        }else if starship.position.x > self.size.width/2{
            starship.position = CGPoint(x: -self.size.width/2, y: starship.position.y)
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
