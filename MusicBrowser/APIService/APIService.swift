//
//  APIService.swift
//  MusicBrowser
//
//  Created by Pankaj Gaikar on 22/03/20.
//  Copyright © 2020 Pankaj Gaikar. All rights reserved.
//

import Foundation
import Combine

enum APIFailureCondition: Error {
    case invalidServerResponse
}

struct Response<T> {
    let value: T
    let response: URLResponse
}

class APIService {
    
    static let shared = APIService()

    public func connectAPI<T: Codable>(_ url: URL) -> AnyPublisher<Response<T>, Error> {

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Response<T> in
            
            guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("status code for server response : \((result.response as? HTTPURLResponse)?.statusCode ?? 200)")
                throw APIFailureCondition.invalidServerResponse
            }
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            } catch {
                print(error)
                throw APIFailureCondition.invalidServerResponse
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}
