//
//  User.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation


public struct RandomUserResponse: Codable {
    let users: [User]?
    let info: ResponseInfo?
    
    init() {
        self.users = []
        self.info = nil
    }
}

struct ResponseInfo: Codable {
    let seed: String?
    let results, page: Int?
    let version: String?
}

struct User: Codable {
    let gender: Gender?
    let name: UserName?
    let location: Location?
    let email: String?
    let login: Login?
    let phone, cell: String?
    let picture: Picture?
    let nat: String?
}

enum Gender: String, Codable {
    case female
    case male
}

struct Location: Codable {
    let street, city, state, postcode: String?
    let coordinates: Coordinates?
    let timezone: Timezone?
}

struct Coordinates: Codable {
    let latitude, longitude: String?
}

enum Postcode: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .integer(value)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        throw DecodingError.typeMismatch(Postcode.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for Postcode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

struct Timezone: Codable {
    let offset, description: String?
}

struct Login: Codable {
    let uuid, username, password, salt: String?
    let md5, sha1, sha256: String?
}

struct UserName: Codable {
    let title: Title?
    let first, last: String?
}

enum Title: String, Codable {
    case madame
    case mademoiselle
    case miss
    case monsieur
    case mr
    case mrs
    case ms
}

struct Picture: Codable {
    let large, medium, thumbnail: String?
}
