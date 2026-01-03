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
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    public static func loadImage(from path: String) -> UIImage? {
        guard FileManager.default.fileExists(atPath: path) else { return nil }
        return UIImage(contentsOfFile: path)
    }
    
    public static func getFileSize(at path: String) -> Int64 {
        guard FileManager.default.fileExists(atPath: path) else { return 0 }
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
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
        guard FileManager.default.fileExists(atPath: path) else { return }
        try? FileManager.default.removeItem(atPath: path)
    }
}
