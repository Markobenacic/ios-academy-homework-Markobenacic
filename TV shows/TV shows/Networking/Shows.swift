//
//  Shows.swift
//  TV shows
//
//  Created by infinum on 27.07.2021..
//

import Foundation

struct Show: Decodable {
    let id: String
    let averageRating: Int?
    let description: String?
    let imageUrl: URL?
    let numberOfReviews: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case averageRating = "average_rating"
        case description
        case imageUrl = "image_url"
        case numberOfReviews = "no_of_reviews"
        case title
    }
}

struct ShowsResponse: Decodable {
    let shows: [Show]
}
