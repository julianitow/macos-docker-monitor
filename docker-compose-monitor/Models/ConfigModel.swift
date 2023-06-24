//
//  ConfigModel.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

struct Config: Identifiable {
    var id = UUID() //identifiable
    let name: String
    let host: String
    let username: String
    let keyPath: String
    var isConnected: Bool = false
    var isSelected: Bool = false
    var containers: Array<Container>
}
