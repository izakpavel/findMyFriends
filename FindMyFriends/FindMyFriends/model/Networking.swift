//
//  Networking.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation
import Combine

// MARK: protocols
protocol RequestProviding {
  var urlRequest: URLRequest { get }
}

protocol APISessionProviding {
  func execute<T>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error> where T : Codable
}

// MARK: enums
enum Endpoint : RequestProviding{
    case allFriends (Int)
    
    var urlRequest: URLRequest {
        let baseUrl = "https://randomuser.me/api/"
        switch self {
        case .allFriends (let count):
            let urlComponents = NSURLComponents(string: baseUrl)!
            let queryItem = URLQueryItem(name: "results", value: "\(count)")
            urlComponents.queryItems = [queryItem]
            return URLRequest(url: urlComponents.url!)
        }
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

// MARK: Session
struct ApiSession: APISessionProviding {
    func execute<T>(_ requestProvider: RequestProviding) -> AnyPublisher<T, Error> where T : Codable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601withFractionalSeconds)
        
        return URLSession.shared.dataTaskPublisher(for: requestProvider.urlRequest)
            .map { print(String(decoding: $0.data, as: UTF8.self)); return $0.data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

struct RandomUsersProvider {
    let apiSession: APISessionProviding

    func getUsers(count: Int) -> AnyPublisher<[User], Never> {
        return apiSession.execute(Endpoint.allFriends(count))
                .catch { error -> Just<RandomUserResponse> in
                    print("Failed with error: \(error)")
                    return Just(RandomUserResponse())
                }
                .map {
                    return $0.results ?? []
                }
                
            .eraseToAnyPublisher()
    }
}
