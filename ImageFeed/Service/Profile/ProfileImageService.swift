//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 10.06.2026.
//
import Foundation

// MARK: - Constants
enum ProfileImageServiceConstants {
    static let didChangeNotification = Notification.Name(
        rawValue: "ProfileImageProviderDidChange"
    )
}

final class ProfileImageService {
    // MARK: - Public properties
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    
    // MARK: - Private properties
    private let decoder = JSONDecoder()
    private let storage = OAuth2Storage.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    // MARK: - Init
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Public methods
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (
            Result<String, Error>
        ) -> Void
    ) {
        assert(Thread.isMainThread)
        guard lastUsername != username else {
            Logger.shared.log(method: "fetchProfileImageURL", error: "NetworkError.invalidRequest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastUsername = username
        
        guard let token = storage.token else {
            Logger.shared.log(method: "fetchProfileImageURL", error: "Authorization token missing")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let urlRequest = makeUserRequest(token: token, username: username) else {
            Logger.shared.log(method: "fetchProfileImageURL", error: "urlRequest is nil")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest, decoder: decoder) { [weak self] (
            result: Result<PublicUserResponseBody,
            Error>
        ) in
            guard let self else {
                Logger.shared.log(method: "fetchProfileImageURL", error: "NetworkError.urlSessionError")
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            switch result {
            case .success(let user):
                self.avatarURL = user.profileImage.small
                postImageURLNotification(url: user.profileImage.small)
                completion(.success(user.profileImage.small))
            case .failure(let error):
                Logger.shared.log(method: "fetchProfileImageURL", error: "\(String(describing: error.self))")
                completion(.failure(error))
            }
            
            self.lastUsername = nil
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeUserRequest(token: String, username: String) -> URLRequest? {
        let url = URL(string: "\(GlobalConstants.baseApiURL)/users/\(username)")
        guard let publicProfileUrl = url else {
            Logger.shared.log(
                method: "makeUserRequest",
                error: "Failed to create URL for user's public profile request",
                parameter: username
            )
            return nil
        }
        
        var request = URLRequest(url: publicProfileUrl)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func postImageURLNotification(url: String) {
        NotificationCenter.default.post(
            name: ProfileImageServiceConstants.didChangeNotification,
            object: self,
            userInfo: ["URL": url]
        )
    }
}
