//
//  SSHService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation
import Shout

enum DOCKER_COMMANDS: String {
    case DOCKER_PS = "docker ps -a --format json | jq -s"
    case DOCKER_LOGS = "docker logs -t --tail 100 "
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
    
    static func fetchContainers(of: Config) -> Array<Container>? {
        guard let session = sessions[of.id] else {
            return nil
        }
        do {
            let (_, output) = try session.capture(DOCKER_COMMANDS.DOCKER_PS.rawValue)
            return OutputParser.parseDockerPStoContainer(output: output)
        } catch {
            print("\(error)")
        }
        return []
    }
    
    static func fetchLogs(of: Config, _for: Container) -> String? {
        guard let session = sessions[of.id] else {
            return nil
        }
        do {
            let cmd = "\(DOCKER_COMMANDS.DOCKER_LOGS.rawValue) \(_for.name)"
            print(cmd)
            let (_, output) = try session.capture(cmd)
            return output
        } catch {
            print("\(error)")
            return "Error fetching logs: \(error)"
        }
    }
}
