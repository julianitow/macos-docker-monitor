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
    
    private static let fileManager = FileManager.default
    
    static func fileExists() -> Bool {
        return fileManager.fileExists(atPath: configPath)
    }
    
    static func directoryExists() -> Bool {
        var isDirectory:ObjCBool = true
        return fileManager.fileExists(atPath: dirPath, isDirectory: &isDirectory)
    }
    
    static func createFile() -> Void {
        let dirUrl = URL(fileURLWithPath: dirPath)
        do {
            try fileManager.createDirectory(at: dirUrl, withIntermediateDirectories: false)
            fileManager.createFile(atPath: configPath, contents: "{ \n\t\"configs\": []\n}\n".data(using: .utf8))
        } catch {
            Utils.alertError(error: error)
            print("\(error)")
        }
    }
    
    static func fetchConfigs() -> Array<Config> {
        if (!fileExists()) {
            createFile()
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
