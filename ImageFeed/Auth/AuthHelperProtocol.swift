//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
