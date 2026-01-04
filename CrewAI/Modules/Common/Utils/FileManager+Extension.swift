//
//  FileManager+Extension.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//


import Foundation
import UIKit

public class FileManagerHelper {
    
    public static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    public static func saveImage(_ image: UIImage, filename: String? = nil) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let fileName = filename ?? "\(UUID.generateString()).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            // Return just the filename, not the full path
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    public static func loadImage(from path: String) -> UIImage? {
        // If path is just a filename, construct full path
        let fullPath: String
        if path.contains("/") {
            // It's already a full path
            fullPath = path
        } else {
            // It's just a filename, construct full path
            fullPath = documentsDirectory.appendingPathComponent(path).path
        }
        
        guard FileManager.default.fileExists(atPath: fullPath) else {
            print("Image file not found at: \(fullPath)")
            return nil
        }
        return UIImage(contentsOfFile: fullPath)
    }
    
    public static func getFileSize(at path: String) -> Int64 {
        // If path is just a filename, construct full path
        let fullPath: String
        if path.contains("/") {
            fullPath = path
        } else {
            fullPath = documentsDirectory.appendingPathComponent(path).path
        }
        
        guard FileManager.default.fileExists(atPath: fullPath) else { return 0 }
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fullPath)
            return attributes[.size] as? Int64 ?? 0
        } catch {
            return 0
        }
    }
    
    
    public static func formatFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    public static func createThumbnail(from image: UIImage, maxSize: CGFloat = 200) -> UIImage {
        let size = image.size
        let ratio = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    public static func deleteFile(at path: String) {
        // If path is just a filename, construct full path
        let fullPath: String
        if path.contains("/") {
            fullPath = path
        } else {
            fullPath = documentsDirectory.appendingPathComponent(path).path
        }
        
        guard FileManager.default.fileExists(atPath: fullPath) else { return }
        try? FileManager.default.removeItem(atPath: fullPath)
    }
}
