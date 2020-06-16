//
//  Character.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import Foundation

/**
Character struct contains all functions to request character(s) information(s).
*/
public struct Character {
    
    public init(client: Client) {self.client = client}
    
    let client: Client
    let networkHandler: NetworkHandler = NetworkHandler()
    
    /**
     Request character by id.
     - Parameters:
        - id: ID of the character.
     - Returns: Character model struct.
     */
    public func getCharacterByID(id: Int, completion: @escaping (Result<CharacterModel, Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "character/"+String(id)) {result in switch result {
        case .success(let data):
            if let character: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(character))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    /**
     Request characters by page number.
     - Parameters:
        - page: Number of result page.
     - Returns: Array of Character model struct.
     */
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
    
    /**
     Request all characters.
     - Returns: Array of Character model struct.
     */
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

/**
 CharacterInfoModel struct for decoding info json response.
 ### Properties
    - **info**: Information about characters count and pagination.
    - **results**: First page with 20 characters.
 
 ### SeeAlso
 - **Info**: Info struct in Network.swift.
 - **CharacterModel**: CharacterModel struct in Character.swift.
 */
struct CharacterInfoModel: Codable {
    let info: Info
    let results: [CharacterModel]
}

/**
 Character struct for decoding character json response.
 ### Properties
    - **id**: The id of the character.
    - **name**: The name of the character.
    - **status**: The status of the character ('Alive', 'Dead' or 'unknown'). s
    - **location**: Name and link to the character's last known location endpoint.
    - **image**: Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    - **episodes**: List of episodes in which this character appeared.
 */
public struct CharacterModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let status: String
    public let location: CharacterLocationModel
    public let image: String
    public let episode: [String]
}

/**
 Location struct for decoding character location json response.
 ### Properties
    - **name**: The name of the location.
    - **url**: Link to the location's own URL endpoint.
 */
public struct CharacterLocationModel: Codable {
    public let name: String
    public let url: String
}

/**
 Enum to filter by status
 */
public enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}


