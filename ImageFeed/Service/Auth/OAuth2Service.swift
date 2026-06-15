//
//  O2AuthService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 22.05.2026.
//
import Foundation

enum AuthError: Error {
    case authError
}

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
            Logger.shared
                .log(
                    method: "fetchAuthToken",
                    error: "Running the same request again"
                )
            completion(.failure(AuthError.authError))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {

            Logger.shared
                .log(
                    method: "fetchAuthToken",
                    error: "urlRequest is nil"
                )
            completion(.failure(AuthError.authError))
            return
        }
        
        let task = URLSession.shared.objectTask(
            for: urlRequest,
            decoder: decoder
        ) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else {
                Logger.shared
                    .log(
                        method: "fetchAuthToken",
                        error: "AuthError.authError"
                    )
                completion(.failure(AuthError.authError))
                return
            }
            
            switch result {
            case .success(let response):
                completion(.success(response.accessToken))
            case .failure(let error):
                Logger.shared
                    .log(
                        method: "fetchAuthToken",
                        error: "\(String(describing: error.self))"
                    )
            }
            
            self.lastCode = nil
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            Logger.shared.log(
                method: "makeOAuthTokenRequest",
                error: "Failed to create URLComponents for OAuth token request",
                parameter: code
            )
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
