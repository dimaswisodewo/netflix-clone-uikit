//
//  Title.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 04/06/23.
//

import Foundation

struct TitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

struct SearchResponse: Codable {
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let id: Int
    let original_name: String?
    let overview: String?
    let poster_path: String?
}

struct YoutubeResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let videoId: String
}
