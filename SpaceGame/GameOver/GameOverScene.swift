import SpriteKit

class GameOverScene: SKScene {
    
    var starfield: SKEmitterNode!
    var gameOverLabel: SKLabelNode!
    var retryButton: SKSpriteNode!
    var score: SKLabelNode!
    var scoreValue: String!
    
    override func didMove(to view: SKView) {
        
        starfield = self.childNode(withName: "starfield") as? SKEmitterNode
        starfield.advanceSimulationTime(20)
        starfield.zPosition = -1
        
        retryButton = self.childNode(withName: "retryButton") as? SKSpriteNode
        
        gameOverLabel = self.childNode(withName: "gameOverLabel") as? SKLabelNode
        
        score = self.childNode(withName: "score") as? SKLabelNode
        score.text = scoreValue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let node = self.nodes(at: location)
            
            if node[0].name == "retryButton"{
                let transition = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: UIScreen.main.bounds.size)
                scene.scaleMode = .resizeFill
                self.view!.presentScene(scene, transition: transition)
            }
        }
    }

}
