//
//  ConfigService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

struct MockedData {
    static func fetchConfigs() -> Array<Config> {
        let config1 = docker_compose_monitor.Config(name: "PROD", host: "192.168.2.3", username: "medissimo", keyPath: "path_to_key", connected: true)
        let config2 = docker_compose_monitor.Config(name: "BETA", host: "192.168.2.3", username: "medissimo", keyPath: "path_to_key", connected: false)
        let config3 = docker_compose_monitor.Config(name: "DEV", host: "192.168.2.3", username: "medissimo", keyPath: "path_to_key", connected: false)
        let data: Array<Config> = [config1, config2, config3]
        return data
    }
}
