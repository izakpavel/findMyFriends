//
//  User.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation


public struct RandomUserResponse: Codable {
    let results: [User]?
    let info: ResponseInfo?
    
    init() {
        self.results = []
        self.info = nil
    }
}

struct ResponseInfo: Codable {
    let seed: String?
    let results, page: Int?
    let version: String?
}

struct User: Codable, Identifiable {
    var id: String {
        return self.email ?? ""
    }
    
    let gender: Gender?
    let name: UserName?
    let location: Location?
    let email: String?
    let login: Login?
    let registered, dob: DateAge?
    let phone, cell: String?
    let picture: Picture?
    let nat: String?
}

struct DateAge: Codable {
    let date: Date?
    let age: Int?
    
    func formattedDate(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .none) -> String? {
        guard let date = self.date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter.string(from: date)
    }
}

enum Gender: String, Codable {
    case female
    case male
    
    var localizedTitle: String? {
        switch self {
            case .female:
                return NSLocalizedString("Female", comment: "female gender")
            case .male:
                return NSLocalizedString("Male", comment: "male gender")
        }
    }
}

struct Street: Codable {
    let number: Int?
    let name: String?
}

struct Location: Codable {
    let street: Street?
    let city, state: String?
    let postcode: Postcode?
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
    let title: String?
    let first, last: String?
    
    var fullName: String? {
        [first, last].compactMap { $0 }.joined(separator: " ")
    }
}

struct Picture: Codable {
    let large, medium, thumbnail: String?
}
