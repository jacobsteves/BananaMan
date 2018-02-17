//
//  ViewController.swift
//  BananaMan
//
//  Created by Jacob Steves on 2018-02-16.
//  Copyright © 2018 Jacob Steves. All rights reserved.
//

import Cocoa
import SpriteKit

struct Constants {
    static let touchBarWidth:CGFloat = 1005.0
    static let backgroundColor = NSColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)
}

class ViewController: NSViewController {
    
    let bananamanView: NSView = NSView()
    let bananamanSKView = BananaManView()
    let mainTapReceiverButton = NSButton(title: " ", target: self, action: #selector(tap))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBananaManView()
        setupMainTapReceiverButton()
    }
    
    func tap() {
        bananamanSKView.bananamanScene.jump()
    }
    
    func setupBananaManView() {
        
        // Fix width
        bananamanSKView.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: bananamanView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Constants.touchBarWidth)
        // Constraints to sides
        let c2 = NSLayoutConstraint(item: bananamanSKView, attribute: .leading, relatedBy: .equal, toItem: bananamanView, attribute: .leading, multiplier: 1.0, constant: 0)
        let c3 = NSLayoutConstraint(item: bananamanSKView, attribute: .trailing, relatedBy: .equal, toItem: bananamanView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let c4 = NSLayoutConstraint(item: bananamanSKView, attribute: .top, relatedBy: .equal, toItem: bananamanView, attribute: .top, multiplier: 1.0, constant: 0)
        let c5 = NSLayoutConstraint(item: bananamanSKView, attribute: .bottom, relatedBy: .equal, toItem: bananamanView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        bananamanView.addConstraint(c1)
        bananamanView.addConstraint(c2)
        bananamanView.addConstraint(c3)
        bananamanView.addConstraint(c4)
        bananamanView.addConstraint(c5)
        
        bananamanView.wantsLayer = true
        bananamanView.layer?.backgroundColor = Constants.backgroundColor.cgColor

        bananamanSKView.initScene()
        
        bananamanView.addSubview(bananamanSKView)
        bananamanView.addSubview(mainTapReceiverButton)
    }
    
    func setupBananaManViewOnAppear() {
        
        if let touchBarView = bananamanView.superview {
            
            // Constraints to sides
            let c1 = NSLayoutConstraint(item: bananamanView, attribute: .leading, relatedBy: .equal, toItem: touchBarView, attribute: .leading, multiplier: 1.0, constant: 0)
            let c2 = NSLayoutConstraint(item: bananamanView, attribute: .trailing, relatedBy: .equal, toItem: touchBarView, attribute: .trailing, multiplier: 1.0, constant: 0)
            let c3 = NSLayoutConstraint(item: bananamanView, attribute: .top, relatedBy: .equal, toItem: touchBarView, attribute: .top, multiplier: 1.0, constant: 0)
            let c4 = NSLayoutConstraint(item: bananamanView, attribute: .bottom, relatedBy: .equal, toItem: touchBarView, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            touchBarView.addConstraint(c1)
            touchBarView.addConstraint(c2)
            touchBarView.addConstraint(c3)
            touchBarView.addConstraint(c4)
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.setupBananaManView()
            })
        }
    }
    
    func setupMainTapReceiverButton() {
        mainTapReceiverButton.isTransparent = true
        mainTapReceiverButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints to sides
        let c1 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .leading, relatedBy: .equal, toItem: bananamanView, attribute: .leading, multiplier: 1.0, constant: 0)
        let c2 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .trailing, relatedBy: .equal, toItem: bananamanView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let c3 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .top, relatedBy: .equal, toItem: bananamanView, attribute: .top, multiplier: 1.0, constant: 0)
        let c4 = NSLayoutConstraint(item: mainTapReceiverButton, attribute: .bottom, relatedBy: .equal, toItem: bananamanView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        bananamanView.addConstraint(c1)
        bananamanView.addConstraint(c2)
        bananamanView.addConstraint(c3)
        bananamanView.addConstraint(c4)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

@available(OSX 10.12.2, *)
extension ViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .bananamanBar
        touchBar.defaultItemIdentifiers = [.bananamanItem]
        touchBar.customizationAllowedItemIdentifiers = [.bananamanItem]
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.bananamanItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = bananamanView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                // Setup bananamanView Constraints on TouchBar View Load
                self.setupBananaManView()
            })
            return customViewItem
        default:
            return nil
        }
    }
}

extension NSTouchBarCustomizationIdentifier {
    static let bananamanBar = NSTouchBarCustomizationIdentifier("com.jacobsteves.BananaMan.BananaManBar")
}

extension NSTouchBarItemIdentifier {
    static let bananamanItem = NSTouchBarItemIdentifier("com.jacobsteves.BananaMan.BananaManBar.main")
}



