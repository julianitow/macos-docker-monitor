//
//  ConfigService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

struct MockedData {
    static func fetchConfigs() -> Array<Config> {
        let config1 = Config(name: "PROD", host: "192.168.2.3", username: "username", keyPath: "path_to_key", isConnected: false, containers: fetchContainersProd())
        let config2 = Config(name: "BETA", host: "192.168.2.3", username: "username", keyPath: "path_to_key", isConnected: false, containers: fetchContainersBeta())
        let config3 = Config(name: "DEV", host: "192.168.2.3", username: "username", keyPath: "path_to_key", isConnected: false, containers: fetchContainersDev())
        let data: Array<Config> = [config1, config2, config3]
        return data
    }
    
    static func fetchContainersProd() -> Array<Container> {
        let container1 = Container(name: "service1prod", status: .RUNNING)
        let container2 = Container(name: "service2prod", status: .STOPPED)
        let container3 = Container(name: "service3prod", status: .EXITED)
        let data: Array<Container> = [container1, container2, container3]
        return data
    }
    
    static func fetchContainersBeta() -> Array<Container> {
        let container1 = Container(name: "service1beta", status: .RUNNING)
        let container2 = Container(name: "service2beta", status: .STOPPED)
        let container3 = Container(name: "service3beta", status: .EXITED)
        let data: Array<Container> = [container1, container2, container3]
        return data
    }
    
    static func fetchContainersDev() -> Array<Container> {
        let container1 = Container(name: "service1Dev", status: .RUNNING)
        let container2 = Container(name: "service2Dev", status: .STOPPED)
        let container3 = Container(name: "service3Dev", status: .EXITED)
        let data: Array<Container> = [container1, container2, container3]
        return data
    }
}
