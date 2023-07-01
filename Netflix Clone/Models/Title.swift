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

/*
{
    etag = FXLaBZSmjLJxleeCn0pn9WYzEbA;
    items =     (
                {
            etag = "JnaeS0tTzk4_DdZ9l4hccq2KNU0";
            id =             {
                kind = "youtube#video";
                videoId = shW9i6k8cB0;
            };
            kind = "youtube#searchResult";
        },
                {
            etag = "PT_VFd4T--TziA-jVu92ZCNQCcg";
            id =             {
                kind = "youtube#video";
                videoId = cqGjhVJWtEg;
            };
            kind = "youtube#searchResult";
        },
                {
            etag = MunCVNno6N0edEvpPMlGDOnUKyA;
            id =             {
                kind = "youtube#video";
                videoId = "GPitD0-mkYA";
            };
            kind = "youtube#searchResult";
        },
                {
            etag = "i-8fHnNPEg5nee586rvsi6TgRZQ";
            id =             {
                kind = "youtube#video";
                videoId = "vzJCCXJLV_o";
            };
            kind = "youtube#searchResult";
        },
                {
            etag = "puW6sAGNwpL9Rb0ZGtA1_fSgYxE";
            id =             {
                kind = "youtube#video";
                videoId = "yPY_PjZmXWw";
            };
            kind = "youtube#searchResult";
        }
    );
    kind = "youtube#searchListResponse";
    nextPageToken = CAUQAA;
    pageInfo =     {
        resultsPerPage = 5;
        totalResults = 1000000;
    };
    regionCode = ID;
}
*/
