//
//  Utils.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 25/06/2023.
//

import Foundation
import SwiftUI

class Utils {
    static func alertError(error: Error) -> Void {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = error.localizedDescription
        alert.informativeText = "Sorry"
        alert.runModal()
    }
}
