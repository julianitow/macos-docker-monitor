//
//  SSHService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation
import Shout

enum DOCKER_COMMANDS: String {
    case DOCKER_PS = "docker ps"
}

class SSHService {
    
    static var sessions: Dictionary<UUID, SSH> = [:]
    
    static func connect(to: Config) -> Bool {
        do {
            let session = try SSH(host: to.host)
            try session.authenticate(username: to.username, privateKey: to.privateKey, publicKey: to.publicKey)
            sessions[to.id] = session
            return true
        } catch {
            print("\(error)")
        }
        return false
    }
    
    static func fetchContainers(of: Config) -> Array<Container> {
        return []
    }
}
