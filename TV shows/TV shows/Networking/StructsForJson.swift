//
//  User.swift
//  TV shows
//
//  Created by infinum on 25.07.2021..
//

import Foundation


struct User: Codable {
    let id: String
    let email: String
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case imageUrl = "image_url"
    }
}

struct UserResponse: Codable {
    let user: User
}
