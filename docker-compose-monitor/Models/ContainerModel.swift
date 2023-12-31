//
//  ContainerModel.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

enum ContainerStatus: String {
    case RUNNING = "RUNNING"
    case STOPPED = "STOPPED"
    case EXITED = "EXITED"
    case RESTARTING = "RESTARTING"
    case PULLING = "PULLING"
}

// TODO: Add information for containers

struct Container: Identifiable {
    var id = UUID()
    let name: String
    let status: ContainerStatus
    var image: String
    
    static func fromJson(json: [String: Any]) throws -> Container {
        guard let name = json["Names"] as? String,
              let state = json["State"] as? String,
              let image = json["Image"] as? String else {
            throw ParsingError.InvalidDictionnary
        }
        
        let status = state == "running" ? ContainerStatus.RUNNING : ContainerStatus.STOPPED
        
        // TODO: Manage more status
        return Container(name: name, status: status, image: image)
    }
}
