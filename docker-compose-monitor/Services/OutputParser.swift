//
//  OutputParser.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

enum OutputParserError: Error {
    case invalidParsing
}

class OutputParser {
    static func parseDockerPStoContainer(output: String) -> [Container] {
        var containers: Array<Container> = []
        if let dictionary = try? JSONSerialization.jsonObject(with: output.data(using: .utf8)!) as? [Any] {
            for c in dictionary {
                if let containerDictionary = c as? [String: Any] {
                    do {
                        containers.append(try Container.fromJson(json: containerDictionary))
                    } catch {
                        print("\(error)")
                    }
                }
            }
        } else {
            print("error in json serialisation")
        }
        print(containers.count)
        return containers
    }
}
