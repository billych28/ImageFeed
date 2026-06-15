//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 06.06.2026.
//
import Foundation

final class ProfileService {
    // MARK: - Public properties
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    // MARK: - Private properties
    private let decoder = JSONDecoder()
    private var lastToken: String?
    private var task: URLSessionTask?
    
    // MARK: - Init
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public methods
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        guard lastToken != token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let urlRequest = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest, decoder: decoder) { [weak self] (
            result: Result<ProfileResponseBody,
            Error>
        ) in
            
            guard let self else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            switch result {
            case .success(let response):
                let profile = getProfile(from: response)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.lastToken = nil
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private methods
    private func makeProfileRequest(token: String) -> URLRequest? {
        let url = URL(string: GlobalConstants.baseApiURL + "me")
        guard let userProfileUrl = url else {
            print("Failed to create URL for user's profile request")
            return nil
        }
        
        var request = URLRequest(url: userProfileUrl)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getProfile(from response: ProfileResponseBody) -> Profile {
        Profile(
            username: response.username,
            name: "\(response.firstName) \(response.lastName)",
            loginName: "@\(response.username)",
            bio: response.bio
        )
    }
}
