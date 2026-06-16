//
//  Logger.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 16.06.2026.
//


final class Logger {
    // MARK: - Public properties
    static let shared = Logger()
    
    private init() {}
    
    func log(
        method: String,
        error: String,
        parameter: String? = nil
    ) {
        let baseMessage = "[\(method)] \(error)"
        if let parameter {
            print(baseMessage + ": \(parameter)")
        } else {
            print(baseMessage)
        }
    }
}
