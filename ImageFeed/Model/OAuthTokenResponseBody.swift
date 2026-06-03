//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 26.05.2026.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
