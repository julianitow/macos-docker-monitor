//
//  ConfigModel.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

enum ConnectionStatus: String {
    case ERROR = "Connection error"
    case CONNECTING = "Connecting"
    case CONNECTED = "Connected"
    case DISCONNECTED = "Disconnected"
}

struct Config: Identifiable {
    var id = UUID() //identifiable
    let name: String
    let host: String
    let username: String
    let publicKey: String
    let privateKey: String
    var port: Int = 22
    var isConnected: Bool = false
    var isSelected: Bool = false
    var containers: Array<Container>
    var connectionStatus: ConnectionStatus = .DISCONNECTED
    
    static func fromJson(json: [String: Any]) throws -> Config {
        guard let name = json["name"] as? String,
              let host = json["host"] as? String,
              let username = json["username"] as? String,
              let publickey = json["publicKey"] as? String,
              let privateKey = json["privateKey"] as? String else {
            throw ParsingError.InvalidDictionnary
        }
        
        return Config(name: name, host: host, username: username, publicKey: publickey, privateKey: privateKey, containers: [])
    }
    
    func toJsonStr(withTabs: Bool = false) -> String {
        if withTabs {
            return "\t{\n \t\t\"name\": \"\(self.name)\",\n \t\t\"host\": \"\(self.host)\",\n \t\t\"username\": \"\(self.username)\",\n \t\t\"publicKey\": \"\(self.publicKey)\",\n \t\t\"privateKey\": \"\(self.privateKey)\",\n \t\t\"port\": \(self.port)\n\t}"
        }
        return "{\n \"name\": \"\(self.name)\",\n \"host\": \"\(self.host)\",\n \"username\": \"\(self.username)\",\n \"publicKey\": \"\(self.publicKey)\",\n \"privateKey\": \"\(self.privateKey)\",\n \"port\": \(self.port)\n}"
    }
}
