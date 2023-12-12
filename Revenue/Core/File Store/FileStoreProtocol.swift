//
//  FileStoreProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

protocol FileStoreProtocol: AnyObject {
    func saveImage(data: Data, with name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchImage(_ uid: String) -> Data?
}
