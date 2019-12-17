//
//  FileCache.swift
//  ViewableMVC
//
//  Created by K Y on 6/17/19.
//  Copyright © 2019 KY. All rights reserved.
//

import Foundation

open class FileCache {

    // MARK: - Properties
    
    let fileManager: FileManager
    let baseDirectory: [URL]
    let baseURL: URL
    
    private var inMemoryCache = NSCache<NSString, NSData>()
    
    // MARK: - Init
    
    public init(_ fileManager: FileManager = FileManager.default,
                _ directory: FileManager.SearchPathDirectory = .cachesDirectory) throws {
        self.fileManager = fileManager
        baseDirectory = fileManager.urls(for: directory,
                                    in: .userDomainMask)
        guard let firstURL = baseDirectory.first else {
            throw NSError(domain: "Could not get base directory in provided FileManager",
                          code: 1, userInfo: nil)
        }
        baseURL = firstURL
    }
    
    // MARK: - Getters
    
    open func getImage(_ name: String) -> Data? {
        var data: Data? = nil
        if let dat = inMemoryCache.object(forKey: name.ns) {
            data =  Data(referencing: dat)
        }
        else {
            let url = baseURL.appendingPathComponent(name)
            do {
                data = try Data(contentsOf: url)
            }
            catch let err as NSError {
                let isError = (err.code == 260 || err.code == 4)
                print(isError ? "File not found" : "Error reading image: \(err)")
            }
        }
        return data
    }
    
    // MARK: - Setters
    
    open func saveImage(_ name: String, _ blob: Data) {
        inMemoryCache.setObject(blob.ns, forKey: name.ns)
        
        let url = baseURL.appendingPathComponent(name)
        do { try blob.write(to: url) }
        catch {
            print("Error saving image: \(error)")
        }
    }
    
    open func deleteImage(_ name: String, _ removeFromCache: Bool = false) {
        if removeFromCache {
            inMemoryCache.removeObject(forKey: name.ns)
        }
    
        let url = baseURL.appendingPathComponent(name)
        do { try fileManager.removeItem(at: url) }
        catch {
            print("Error deleting image: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    open func deleteAllFiles() {
        do {
            let urls = try fileManager.contentsOfDirectory(at: baseURL,
                                                           includingPropertiesForKeys: nil,
                                                           options: .skipsPackageDescendants)
            urls.forEach {
                do { try fileManager.removeItem(at: $0) }
                catch {
                    print("Error removing file: \($0) with error: \(error)")
                }
            }
        }
        catch {
            print("Error reading files in : \(baseURL)")
        }
    }
}
