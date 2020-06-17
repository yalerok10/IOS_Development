//
//  Episode.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import Foundation

public struct Episode {
    
    public init(client: Client) {self.client = client}
    
    let client: Client
    let networkHandler: NetworkHandler = NetworkHandler()
    
    public func getEpisodesByPageNumber(pageNumber: Int, completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(pageNumber)) {result in switch result {
        case .success(let data):
            if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                completion(.success(infoModel.results))
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
    
    public func getAllEpisodes(completion: @escaping (Result<[EpisodeModel], Error>) -> Void) {
        var allEpisodes = [EpisodeModel]()
        networkHandler.performAPIRequestByMethod(method: "episode") {result in switch result {
        case .success(let data):
            if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                allEpisodes = infoModel.results
                let episodesDispatchGroup = DispatchGroup()
                
                for index in 2...infoModel.info.pages {
                    episodesDispatchGroup.enter()
                    self.getEpisodesByPageNumber(pageNumber: index) {result in switch result {
                    case .success(let episodes):
                        allEpisodes.append(contentsOf:episodes)
                        episodesDispatchGroup.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        }}
                }
                episodesDispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(.success(allEpisodes.sorted { $0.id < $1.id }))
                }
            }
        case .failure(let error):
            completion(.failure(error))
            }}
    }
}

struct EpisodeInfoModel: Codable {
    let info: Info
    let results: [EpisodeModel]
}

public struct EpisodeModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let airDate: String = "air_date"
    public let episode: String
    public let characters: [String]
    public let url: String
    public let created: String
}
