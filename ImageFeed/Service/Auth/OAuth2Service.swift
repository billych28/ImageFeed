//
//  O2AuthService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 22.05.2026.
//
import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    // MARK: - Private properties
    private let decoder = JSONDecoder()
    private var lastCode: String?
    private var task: URLSessionTask?
    
    // MARK: - Init
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public methods
    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(
            for: urlRequest,
            decoder: decoder
        ) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            switch result {
            case .success(let response):
                completion(.success(response.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.lastCode = nil
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("Failed to create URLComponents for OAuth token request")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: GlobalConstants.accessKey),
            URLQueryItem(
                name: "client_secret",
                value: GlobalConstants.secretKey
            ),
            URLQueryItem(
                name: "redirect_uri",
                value: GlobalConstants.redirectURI
            ),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
