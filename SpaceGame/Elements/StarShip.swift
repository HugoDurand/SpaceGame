//
//  StarShip.swift
//  SpaceGame
//
//  Created by Hugo Durand on 24/10/2019.
//  Copyright © 2019 ESGI. All rights reserved.
//
import SpriteKit
import Foundation

class StarShip: SKSpriteNode {
    var fileName: String
    
    init(fileName: String) {
        
        self.fileName = fileName
        let texture = SKTexture(imageNamed: fileName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
