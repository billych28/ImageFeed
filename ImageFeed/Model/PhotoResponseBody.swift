//
//  PhotoResponseBody.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 01.07.2026.
//

struct PhotoResponseBody: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: PhotoUrlRespnoseBody
}

struct PhotoUrlRespnoseBody: Decodable {
    let small: String
    let full: String
}
