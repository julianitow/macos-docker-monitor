//
//  ParseConfigService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

class ConfigParserService {
    
    static func fetchConfigs() -> Array<Config> {
        let configPath = "/Users/julianitow/.docker-inspector/config.json"
        let path = URL(fileURLWithPath: configPath)
        do {
            let data = try String(contentsOf: path)
            return parseData(data)
        } catch  {
            print("Erreur lors de la lecture du fichier : \(error)")
        }
        return []
    }
    
    private static func parseData(_ content: String) -> Array<Config> {
        var configurations: Array<Config> = []
        if let dictionary = try? JSONSerialization.jsonObject(with: content.data(using: .utf8)!) as? [String: Any] {
            if let configs = dictionary["configs"]! as? [Any] {
                for config in configs {
                    if let configDictionary = config as? [String: Any] {
                        do {
                            configurations.append(try Config.fromJson(json: configDictionary))
                        } catch {
                            print("\(error)")
                        }
                    }
                }
            }
        } else {
            print("error in json serialisation")
        }
        return configurations
    }
}
