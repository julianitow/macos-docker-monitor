//
//  SSHService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 25/06/2023.
//

import Foundation

class MockSSHService {
        
    static func connect(to: Config) throws -> Bool {
        return true
    }
    
    static func fetchContainers(of: Config) throws -> Array<Container>? {
        return of.containers
    }
    
    static func fetchLogs(of: Config, _for: Container) throws -> String? {
        return "Ce sont des logs d'un service"
    }
    
    static func dockerRun(of: Config, _for: Container) throws -> Bool {
        return true
    }
    
    static func dockerStop(of: Config, _for: Container) throws -> Bool {
        return true
    }
    
    static func dockerPull(of: Config, _for: Container) throws -> String {
        return "Le conteneur a été mis à jour tqt"
    }
}
