//
//  PexelResponse.swift
//  SnapchatClone
//
//  Created by Messiah on 1/5/24.
//

import Foundation

struct PexelsResponse: Codable {
    let videos: [PexelsVideo]
}
struct PexelsVideo: Codable {
    let id: Int
    let url: String
    let video_files: [PexelsVideoFile]
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case video_files = "video_files"
    }
}
struct PexelsVideoFile: Codable {
    let link: URL
}
