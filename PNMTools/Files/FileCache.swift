//
//  FileCache.swift
//  ViewableMVC
//
//  Created by K Y on 6/17/19.
//  Copyright © 2019 KY. All rights reserved.
//

import Foundation

open class ImageCache {

    // MARK: - Properties
    
    let fileManager: FileManager
    let baseDirectory: [URL]
    let baseURL: URL
    
    private var inMemoryCache = NSCache<NSString, NSData>()
    
    // MARK: - Init
    
    public init(_ fileManager: FileManager = FileManager.default) throws {
        self.fileManager = fileManager
        baseDirectory = fileManager.urls(for: .cachesDirectory,
                                    in: .userDomainMask)
        guard let firstURL = baseDirectory.first else {
            throw NSError(domain: "Could not get base directory in provided FileManager",
                          code: 1, userInfo: nil)
        }
        baseURL = firstURL
    }
    
    // MARK: - Getters
    
    open func getImage(_ name: String) -> Data? {
        if let dat = inMemoryCache.object(forKey: name.ns) {
            return Data(referencing: dat)
        }
        else {
            let url = baseURL.appendingPathComponent(name)
            do {
                let data = try Data(contentsOf: url)
                return data
            }
            catch let err as NSError {
                let isError = (err.code == 260 || err.code == 4)
                print(isError ? "File not found" : "Error reading image: \(err)")
            }
        }
        return nil
    }
    
    // MARK: - Setters
    
    open func saveImage(_ name: String, _ imageData: Data) {
        inMemoryCache.setObject(imageData.ns, forKey: name.ns)
        let url = baseURL.appendingPathComponent(name)
        do {
            try imageData.write(to: url)
        }
        catch {
            print("Error saving image: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    open func deleteAllFiles() {
        do {
            let files = try fileManager.contentsOfDirectory(at: baseURL,
                                                            includingPropertiesForKeys: nil,
                                                            options: .skipsPackageDescendants)
            for file in files {
                do {
                    try fileManager.removeItem(at: file)
                }
                catch {
                    print("Error removing file: \(file) with error: \(error)")
                }
            }
        }
        catch {
            print("Error reading files in : \(baseURL)")
        }
    }
}
