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
}

struct Container: Identifiable {
    var id = UUID()
    let name: String
    let status: ContainerStatus
}
