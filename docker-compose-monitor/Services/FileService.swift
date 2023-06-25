//
//  FileService.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 25/06/2023.
//

import Foundation

class FileService {
    private static let fileManager = FileManager.default
    
    static func fileExists(_ filePath: String) -> Bool {
        return fileManager.fileExists(atPath: filePath)
    }
    
    static func directoryExists(_ dirPath: String) -> Bool {
        var isDirectory:ObjCBool = true
        return fileManager.fileExists(atPath: dirPath, isDirectory: &isDirectory)
    }
    
    static func createFile(dirPath: String, filePath: String, withContent: String?) -> Void {
        let dirUrl = URL(fileURLWithPath: dirPath)
        do {
            try fileManager.createDirectory(at: dirUrl, withIntermediateDirectories: false)
            fileManager.createFile(atPath: filePath, contents: (withContent != nil) ? withContent!.data(using: .utf8) : "".data(using: .utf8))
        } catch {
            Utils.alertError(error: error)
            print("\(error)")
        }
    }
    
    static func readFile(filePath: String) throws -> String {
        let path = URL(fileURLWithPath: filePath)
        do {
            return try String(contentsOf: path)
        } catch {
            throw error
        }
    }
    
    static func writeToFile(filePath: String, content: String) throws -> Void {
        do {
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            throw error
        }
    }
}
