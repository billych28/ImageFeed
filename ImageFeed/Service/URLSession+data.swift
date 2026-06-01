//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 26.05.2026.
//
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fullfilCompletionOnTheMainThread: (
            Result<Data, Error>
        ) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard
                let data = data,
                let response = response as? HTTPURLResponse
            else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            guard(200..<300).contains(response.statusCode) else {
                completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            
            fullfilCompletionOnTheMainThread(.success(data))
        }

        
        return task
    }
}
