//
//  BananaManView.swift
//  BananaMan
//
//  Created by Jacob Steves on 2018-02-16.
//  Copyright © 2018 Jacob Steves. All rights reserved.
//

import Cocoa
import SpriteKit

class BananaManView: SKView {
    
    let bananamanScene = BananaManScene(size: CGSize(width: 1005, height: 30))
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    func initScene() {
        self.presentScene(bananamanScene)
    }
    
}
