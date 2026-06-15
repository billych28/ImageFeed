//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 15.06.2026.
//
import Foundation

struct PhotosListResponseBody: Decodable {
    let photos: [Photo]
}

enum ImagesListServiceConstants {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListProviderDidChange")
}

final class ImagesListService {
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    
    private let decoder = JSONDecoder()
    private let storage = OAuth2Storage.shared
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        task?.cancel()
        
        let page = (lastLoadedPage ?? 0) + 1
        
        guard let token = storage.token else {
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard let request = makePhotosListRequest(token: token, page: page) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request, decoder: decoder) {
            [weak self]
            (result: Result<[Photo], Error>) in
            
            guard let self else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            switch result {
            case .success(let response):
                self.postImagesListNotification(photos: response)
                self.photos = response
                self.lastLoadedPage = page
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makePhotosListRequest(token: String, page: Int) -> URLRequest? {
        guard let url = URL(string: GlobalConstants.baseApiURL + "photos?page=\(page)") else {
            print("Faild to create URL for photos request")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func postImagesListNotification(photos: [Photo]) {
        NotificationCenter.default.post(
            name: ImagesListServiceConstants.didChangeNotification,
            object: self,
            userInfo: ["Photos": photos]
        )
    }
}
