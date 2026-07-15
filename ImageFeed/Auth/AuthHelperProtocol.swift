//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
import Foundation

protocol AuthHelperProtocol {
    var authURLRequest: URLRequest? { get }
    func getCode(from url: URL) -> String?
}
