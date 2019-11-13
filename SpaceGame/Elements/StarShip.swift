import SpriteKit
import Foundation

class StarShip: SKSpriteNode {
    var fileName: String
    var torpedoSound = SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
    
    init(fileName: String) {
        
        self.fileName = fileName
        let texture = SKTexture(imageNamed: fileName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fireMissile(scene: SKScene, photonMissileCategory:UInt32, vilainCategory:UInt32) {
        self.run(torpedoSound)
        
        let missileNode = SKSpriteNode(imageNamed: "missile")
        missileNode.position = self.position
        missileNode.position.y += 5
        
        missileNode.physicsBody = SKPhysicsBody(circleOfRadius: missileNode.size.width / 2)
        missileNode.physicsBody?.isDynamic = true
        
        missileNode.physicsBody?.categoryBitMask = photonMissileCategory
        missileNode.physicsBody?.contactTestBitMask = vilainCategory
        missileNode.physicsBody?.collisionBitMask = 0
        missileNode.physicsBody?.usesPreciseCollisionDetection = true
        
        scene.addChild(missileNode)
        
        let animationDuration:TimeInterval = 0.4
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: self.position.x, y: UIScreen.main.bounds.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        missileNode.run(SKAction.sequence(actionArray))
        
    }
}
