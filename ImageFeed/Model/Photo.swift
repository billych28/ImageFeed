//
//  Photo.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 15.06.2026.
//

struct Photo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let isLiked: Bool
    let urls: PhotoUrl
}

struct PhotoUrl: Decodable {
    let small: String
    let full: String
}
