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
    
    var sessions: Array<SSH> = []
    
    static func connect(to: Config) -> Bool {
        do {
            let session = try SSH(host: to.host)
            try session.authenticate(username: to.username, privateKey: to.privateKey, publicKey: to.publicKey)
            let (status, output) = try session.capture(DOCKER_COMMANDS.DOCKER_PS.rawValue)
            print(output)
            return true
        } catch {
            print("\(error)")
        }
        return false
    }
}
