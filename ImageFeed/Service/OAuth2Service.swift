//
//  O2AuthService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 22.05.2026.
//
import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchAuthToken(
        code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.data(
            for: urlRequest,
            completion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let data):
                    completion(decodeToken(from: data))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        
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
    
    private func decodeToken(from data: Data) -> Result<String, Error> {
        do {
            let oAuthTokenResponseBody = try JSONDecoder().decode(
                OAuthTokenResponseBody.self,
                from: data
            )
            return .success(oAuthTokenResponseBody.accessToken)
        } catch {
            return .failure(NetworkError.decodingError(error))
        }
    }
}
