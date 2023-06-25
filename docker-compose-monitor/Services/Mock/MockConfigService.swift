//
//  ConfigService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

struct MockedData {
    static func fetchConfigs() -> Array<Config> {
        let config1 = Config(name: "PROD", host: "192.168.2.3", username: "username", publicKey: "path_to_key", privateKey: "path_to_key", isConnected: false, containers: fetchContainersProd())
        let config2 = Config(name: "BETA", host: "192.168.2.3", username: "username", publicKey: "path_to_key", privateKey: "path_to_key", isConnected: false, containers: fetchContainersBeta())
        let config3 = Config(name: "DEV", host: "192.168.2.3", username: "username", publicKey: "path_to_key", privateKey: "path_to_key", isConnected: false, containers: fetchContainersDev())
        let data: Array<Config> = [config1, config2, config3]
        return data
    }
    
    static func fetchContainersProd() -> Array<Container> {
        let container1 = Container(name: "service1prod", status: .RUNNING, image: "Image")
        let container2 = Container(name: "service2prod", status: .STOPPED, image: "Image")
        let container3 = Container(name: "service3prod", status: .EXITED, image: "Image")
        let data: Array<Container> = [container1, container2, container3]
        return data
    }
    
    static func fetchContainersBeta() -> Array<Container> {
        let container1 = Container(name: "service1beta", status: .RUNNING, image: "Image")
        let container2 = Container(name: "service2beta", status: .STOPPED, image: "Image")
        let container3 = Container(name: "service3beta", status: .EXITED, image: "Image")
        let container4 = Container(name: "service4beta", status: .RUNNING, image: "Image")
        let container5 = Container(name: "service5beta", status: .STOPPED, image: "Image")
        let container6 = Container(name: "service6beta", status: .EXITED, image: "Image")
        let container7 = Container(name: "service7beta", status: .RUNNING, image: "Image")
        let container8 = Container(name: "service8beta", status: .STOPPED, image: "Image")
        let container9 = Container(name: "service9beta", status: .EXITED, image: "Image")
        let container10 = Container(name: "service10beta", status: .RUNNING, image: "Image")
        let container11 = Container(name: "service11beta", status: .STOPPED, image: "Image")
        let container12 = Container(name: "service12beta", status: .EXITED, image: "Image")
        let container13 = Container(name: "service13beta", status: .RUNNING, image: "Image")
        let container14 = Container(name: "service14beta", status: .STOPPED, image: "Image")
        let container15 = Container(name: "service15beta", status: .EXITED, image: "Image")
        let container16 = Container(name: "service16beta", status: .RUNNING, image: "Image")
        let container17 = Container(name: "service17beta", status: .STOPPED, image: "Image")
        let container18 = Container(name: "service18beta", status: .EXITED, image: "Image")
        let container19 = Container(name: "service19beta", status: .RUNNING, image: "Image")
        let container20 = Container(name: "service20beta", status: .STOPPED, image: "Image")
        let container21 = Container(name: "service21beta", status: .EXITED, image: "Image")
        let container22 = Container(name: "service22beta", status: .RUNNING, image: "Image")
        let container23 = Container(name: "service23beta", status: .STOPPED, image: "Image")
        let container24 = Container(name: "service24beta", status: .EXITED, image: "Image")
        let container25 = Container(name: "service25beta", status: .EXITED, image: "Image")
        let container26 = Container(name: "service26beta", status: .RUNNING, image: "Image")
        let container27 = Container(name: "service27beta", status: .STOPPED, image: "Image")
        let container28 = Container(name: "service28beta", status: .EXITED, image: "Image")
        let container29 = Container(name: "service29beta", status: .RUNNING, image: "Image")
        let container30 = Container(name: "service30beta", status: .STOPPED, image: "Image")
        let container31 = Container(name: "service31beta", status: .EXITED, image: "Image")
        let data: Array<Container> = [container1, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, container15, container16, container17, container18, container19, container20, container21, container22, container23, container24, container25, container26, container27, container28, container29, container30, container31]
        return data
    }
    
    static func fetchContainersDev() -> Array<Container> {
        let container1 = Container(name: "service1Dev", status: .RUNNING, image: "Image")
        let container2 = Container(name: "service2Dev", status: .STOPPED, image: "Image")
        let container3 = Container(name: "service3Dev", status: .EXITED, image: "Image")
        let data: Array<Container> = [container1, container2, container3]
        return data
    }
}
