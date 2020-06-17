//
//  Character.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import Foundation

public struct Character {
    
    public init(client: Client) {self.client = client}
    
    let client: Client
    let networkHandler: NetworkHandler = NetworkHandler()

    public func getCharactersByPageNumber(pageNumber: Int, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "character/"+"?page="+String(pageNumber)) {result in switch result {
        case .success(let data):
            if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(infoModel.results))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
 
    public func getAllCharacters(completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        var allCharacters = [CharacterModel]()
        networkHandler.performAPIRequestByMethod(method: "character") {result in switch result {
        case .success(let data):
            if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                allCharacters = infoModel.results
                let charactersDispatchGroup = DispatchGroup()
                
                for index in 2...infoModel.info.pages {
                    charactersDispatchGroup.enter()
                    self.getCharactersByPageNumber(pageNumber: index) {result in switch result {
                    case .success(let characters):
                        allCharacters.append(contentsOf:characters)
                        charactersDispatchGroup.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        }}
                }
                charactersDispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(.success(allCharacters.sorted { $0.id < $1.id }))
                }
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
}

struct CharacterInfoModel: Codable {
    let info: Info
    let results: [CharacterModel]
}

public struct CharacterModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let status: String
    public let location: CharacterLocationModel
    public let image: String
    public let episode: [String]
}

public struct CharacterLocationModel: Codable {
    public let name: String
    public let url: String
}

public enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}


