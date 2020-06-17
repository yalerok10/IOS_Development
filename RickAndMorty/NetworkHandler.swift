//
//  NetworkHandler.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 13.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

enum NetworkHandlerError: Error {
    case invalidURL
    case invalidResponse
    case apiError
    case decodingError
}

public struct NetworkHandler {
    let baseURL: String = "https://rickandmortyapi.com/api/"
    
    func performAPIRequestByMethod(method: String, completion: @escaping (Result<Data, NetworkHandlerError>) -> Void) {
        if let url = URL(string: baseURL+method) {
            print("HTTP-Request: "+baseURL+method)
            let urlSession = URLSession.shared
            urlSession.dataTask(with: url) { result in switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(data))
            case .failure( _):
                completion(.failure(.apiError))
                }
            }.resume()
        } else {
            completion(.failure(.invalidURL))
        }
    }
    
    func decodeJSONData<T: Codable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
