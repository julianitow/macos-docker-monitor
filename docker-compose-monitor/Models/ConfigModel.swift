//
//  ConfigModel.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

enum ParsingError: Error {
    case InvalidDictionnary
}

struct Config: Identifiable {
    var id = UUID() //identifiable
    let name: String
    let host: String
    let username: String
    let keyPath: String
    var isConnected: Bool = false
    var isSelected: Bool = false
    var containers: Array<Container>
    
    static func fromJson(json: [String: Any]) throws -> Config {
        print(json)
        guard let name = json["name"] as? String,
              let host = json["host"] as? String,
              let username = json["username"] as? String,
              let keyPath = json["key"] as? String else {
            throw ParsingError.InvalidDictionnary
        }
        return Config(name: name, host: host, username: username, keyPath: keyPath, containers: [])
    }
}
