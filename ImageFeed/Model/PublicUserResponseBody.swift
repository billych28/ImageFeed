//
//  PublicUserResponseBody.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 15.06.2026.
//

struct PublicUserResponseBody: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
}
