//
//  ParseConfigService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import Foundation

class ConfigParserService {
    
    static let dirPath = "\(NSHomeDirectory())/.docker-inspector"
    static let configPath = "\(dirPath)/config.json"
    
    static func fetchConfigs() -> Array<Config> {
        if (!FileService.fileExists(configPath)) {
            FileService.createFile(dirPath: dirPath, filePath: configPath, withContent: "{ \n\t\"configs\": []\n}\n")
        }
        let path = URL(fileURLWithPath: configPath)
        do {
            let data = try String(contentsOf: path)
            return parseData(data)
        } catch  {
            Utils.alertError(error: error)
            print("Erreur lors de la lecture du fichier : \(error)")
        }
        return []
    }
    
    //TODO: throws error
    static func addConfig(config: Config) -> Void {
        print(config.toJsonStr())
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
                            Utils.alertError(error: error)
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
