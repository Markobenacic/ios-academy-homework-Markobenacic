//
//  Reviews.swift
//  TV shows
//
//  Created by infinum on 28.07.2021..
//

import Foundation

struct Review: Decodable {
    let id: String
    let comment: String
    let rating: Int
    let showID: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showID = "show_id"
        case user
    }
}

struct WriteReviewResponse: Decodable {
    let id: String?
    let comment: String?
    let rating: Int?
    let show_id: Int?
    let user: User?
}

struct Pagination: Decodable {
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case page
        case items
        case pages
    }
}

struct Meta: Decodable {
    let pagination: Pagination
}

struct ReviewResponse: Decodable {
    let reviews: [Review]
    let meta: Meta
}
