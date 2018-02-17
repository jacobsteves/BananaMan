//
//  WindowController.swift
//  BananaMan
//
//  Created by Jacob Steves on 2018-02-16.
//  Copyright © 2018 Jacob Steves. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        guard let viewController = contentViewController as? ViewController else {
            return nil
        }
        return viewController.makeTouchBar()
    }
}
