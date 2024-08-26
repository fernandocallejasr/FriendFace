//
//  User.swift
//  FriendFace
//
//  Created by Fernando Callejas on 15/08/24.
//

import Foundation
import SwiftData

@Model
class User: Codable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    @Relationship(deleteRule: .cascade) var friends: [Friend]
    
    init(id: UUID, isActive: Bool, name: String, age: Int, company: String, email: String, address: String, about: String, registered: Date, tags: [String], friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
    
    enum CodingKeys: CodingKey {
        case id
        case isActive
        case name
        case age
        case company
        case email
        case address
        case about
        case registered
        case tags
        case friends
    }
    
    required init(from decoder: Decoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.about = try container.decode(String.self, forKey: .about)
        
        let registeredDateString = try container.decode(String.self, forKey: .registered)
        if let decodedRegisteredDate = dateFormatter.date(from: registeredDateString) {
            self.registered = decodedRegisteredDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .registered, in: container, debugDescription: "Date string does not match format expected by formatter")
        }
        
        self.tags = try container.decode([String].self, forKey: .tags)
        self.friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    func encode(to encoder: Encoder) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.company, forKey: .company)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.about, forKey: .about)
        
        let registeredString = dateFormatter.string(from: self.registered)
        try container.encode(registeredString, forKey: .registered)
        
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.friends, forKey: .friends)
    }
}
