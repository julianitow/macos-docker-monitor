//
//  View.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation
import SwiftUI

extension View {
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
                let win = NSWindow(contentViewController: controller)
                win.contentViewController = controller
                win.title = title
                win.makeKeyAndOrderFront(sender)
                return win
    }
}
