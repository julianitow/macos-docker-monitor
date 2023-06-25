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
        do {
            let data = try FileService.readFile(filePath: configPath)
            return parseData(data)
        } catch  {
            Utils.alertError(error: error)
            print("Erreur lors de la lecture du fichier : \(error)")
        }
        return []
    }
    
    //TODO: throws error
    static func addConfig(config: Config) -> Void {
        do {
            var configs = fetchConfigs()
            configs.append(config)
            let configsJsonStr = configsToJsonStr(configs: configs)
            try FileService.writeToFile(filePath: configPath, content: configsJsonStr)
        } catch {
            Utils.alertError(error: error)
            print("\(error)")
        }
    }
    
    static func configsToJsonStr(configs: [Config]) -> String {
        var jsonStr = "{\n\t\"configs\": [\n\t\t"
        for config in configs {
            jsonStr += config.toJsonStr(withTabs: true)
            jsonStr += ","
        }
        jsonStr += "\t\n]\n}"
        return jsonStr
    }
    
    private static func parseData(_ content: String) -> Array<Config> {
        var configurations: Array<Config> = []
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!) as? [String: Any] {
                if let configs = dictionary["configs"] as? [Any] {
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
                } else {
                    Utils.alert(message: "Invalid configuration", type: .critical, informativeText: "Configuration file is invalid")
                }
            }
            return configurations
        } catch {
            Utils.alertError(error: error)
        }
        return []
    }
}
