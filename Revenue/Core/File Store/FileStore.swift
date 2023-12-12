//
//  FileStore.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

final class FileStore {
    
// MARK: - Properties
    
    private let manager = FileManager.default
}

// MARK: - FileStoreProtocol

extension FileStore: FileStoreProtocol {
    func fetchImage(_ uid: String) -> Data? {
        guard let directoryUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = directoryUrl.appendingPathComponent(uid)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                return try Data(contentsOf: fileUrl)
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func saveImage(data: Data, with name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let directlyUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = directlyUrl.appendingPathComponent(name)
        do {
            try data.write(to: fileUrl)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
