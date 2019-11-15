import SpriteKit

class SelectStarShipScene: SKScene {
    
    var playButton: SKSpriteNode!
    var StarShipLabel: SKLabelNode!
    var leftArrow: SKSpriteNode!
    var rightArrow: SKSpriteNode!
    
    var starships = ["millenium-falcon", "starship2"]
    var starShipImage: SKSpriteNode!
    var selectedStarShip : String!
    
    var index = 0
    
    let dictionnary: [String: SKTexture] = [
        "millenium-falcon": SKTexture(imageNamed: "millenium-falcon"),
        "starship2": SKTexture(imageNamed: "starship2"),
    ]
    
    override func didMove(to view: SKView) {

        playButton = self.childNode(withName: "playButton") as? SKSpriteNode
        leftArrow = self.childNode(withName: "leftArrow") as? SKSpriteNode
        rightArrow = self.childNode(withName: "rightArrow") as? SKSpriteNode
        
        selectedStarShip = starships[index]
        starShipImage = self.childNode(withName: "starShipImage") as? SKSpriteNode
        starShipImage.texture = dictionnary[selectedStarShip]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let node = self.nodes(at: location)

            if node[0].name == "playButton"{
                let transition = SKTransition.fade(withDuration: 0.5)
                let scene = GameScene(size: UIScreen.main.bounds.size)
                scene.scaleMode = .resizeFill
                scene.selectedStarShip = selectedStarShip
                self.view!.presentScene(scene, transition: transition)
            }
            
            if node[0].name == "leftArrow"{
                if index > 0{
                    index -= 1
                    selectedStarShip = starships[index]
                    starShipImage.texture = dictionnary[selectedStarShip]
                }
            }
            if node[0].name == "rightArrow"{
                if index < starships.count-1{
                    index += 1
                    selectedStarShip = starships[index]
                    starShipImage.texture = dictionnary[selectedStarShip]
                }
            }
        }
    }
}
