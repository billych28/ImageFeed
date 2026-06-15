//
//  Photo.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 15.06.2026.
//
import Foundation

struct Photo: Decodable {
    let id: String
    let description: String?
    let urls: PhotoUrl
}

struct PhotoUrl: Decodable {
    let thumb: String
    let full: String
}
