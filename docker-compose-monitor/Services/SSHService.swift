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
    case DOCKER_STOP = "docker stop "
    case DOCKER_START = "docker start "
    case DOCKER_PULL = "docker pull "
}

class SSHService {
    
    static var sessions: Dictionary<UUID, SSH> = [:]
    
    static func connect(to: Config) throws -> Bool {
        do {
            let session = try SSH(host: to.host)
            try session.authenticate(username: to.username, privateKey: to.privateKey, publicKey: to.publicKey)
            sessions[to.id] = session
            return true
        } catch {
            print("\(error)")
            throw error
        }
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
    
    static func dockerRun(of: Config, _for: Container) -> Bool {
        guard let session = sessions[of.id] else {
            return false
        }
        do {
            let cmd = "\(DOCKER_COMMANDS.DOCKER_START.rawValue) \(_for.name)"
            let (_, _) = try session.capture(cmd)
            return true
        } catch {
            print("\(error)")
        }
        return false
    }
    
    static func dockerStop(of: Config, _for: Container) -> Bool {
        guard let session = sessions[of.id] else {
            return false
        }
        do {
            let cmd = "\(DOCKER_COMMANDS.DOCKER_STOP.rawValue) \(_for.name)"
            let (_, _) = try session.capture(cmd)
            return true
        } catch {
            print("\(error)")
        }
        return false
    }
    
    static func dockerPull(of: Config, _for: Container) -> String {
        guard let session = sessions[of.id] else {
            return "No session"
        }
        do {
            let cmd = "\(DOCKER_COMMANDS.DOCKER_PULL.rawValue) \(_for.image)"
            let (_, output) = try session.capture(cmd)
            return output
        } catch {
            print("\(error)")
        }
        return "Eror while pulling image"
    }
}
