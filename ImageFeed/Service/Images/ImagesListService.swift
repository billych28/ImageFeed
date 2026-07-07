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
    static let didChangeNotification = Notification.Name("ImagesListProviderDidChange")
}

final class ImagesListService {
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    
    private let decoder = JSONDecoder()
    private let storage = OAuth2Storage.shared
    private var lastLoadedPage: Int?
    private var fetchNextPageTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchPhotosNextPage(
        completion: @escaping (Result<[Photo], Error>) -> Void
    ) {
        fetchNextPageTask?.cancel()
        
        let page = (lastLoadedPage ?? 0) + 1
        
        guard let token = storage.token else {
            Logger.shared.log(method: MethodToLog.ImageListService.fetchPhotosNextPage.rawValue, error: "Authorization token missing")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let request = makePhotosListRequest(token: token, page: page) else {
            Logger.shared.log(method: MethodToLog.ImageListService.fetchPhotosNextPage.rawValue, error: "urlRequest is nil")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(
            for: request,
            decoder: decoder
        ) {
            [weak self]
            (result: Result<[PhotoResponseBody], Error>) in
            
            guard let self else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            switch result {
            case .success(let response):
                let photos = response.map(getPhoto)
                postImagesListNotification(photos: photos)
                self.photos.append(contentsOf: photos)
                self.lastLoadedPage = page
                completion(.success(photos))
            case .failure(let error):
                Logger.shared.log(method: MethodToLog.ImageListService.fetchPhotosNextPage.rawValue, error: "\(String(describing: error.self))")
                completion(.failure(error))
            }
            
            fetchNextPageTask = nil
        }
        fetchNextPageTask = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>) -> Void
    ) {
        changeLikeTask?.cancel()
        
        guard let token = storage.token else {
            Logger.shared.log(method: MethodToLog.ImageListService.changeLike.rawValue, error: "Authorization token missing")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike, token: token) else {
            Logger.shared.log(method: MethodToLog.ImageListService.changeLike.rawValue, error: "urlRequest is nil")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request, decoder: decoder) { [weak self] (
            result: Result<ImageLikeResponseBody,
            Error>
        ) in
            guard let self else {
                Logger.shared.log(method: MethodToLog.ImageListService.changeLike.rawValue, error: "NetworkError.urlSessionError")
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(
                        where: { $0.id == photoId
                        }) {
                        let photo = self.photos[index]
                        
                        let newPhoto = Photo(
                            id: photo.id,
                            width: photo.width,
                            height: photo.height,
                            createdAt: photo.createdAt,
                            description: photo.description,
                            isLiked: !photo.isLiked,
                            urls: photo.urls
                        )
                        
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                Logger.shared.log(method: MethodToLog.ImageListService.changeLike.rawValue, error: "\(String(describing: error.self))")
                completion(.failure(error))
            }
            
            changeLikeTask = nil
        }
        
        changeLikeTask = task
        task.resume()
    }
    
    private func makePhotosListRequest(token: String, page: Int) -> URLRequest? {
        guard let url = URL(string: GlobalConstants.baseApiURL + "photos?page=\(page)") else {
            print("Failed to create URL for photos request")
            Logger.shared.log(
                method: "makePhotosListRequest",
                error: "Failed to create URL for photos request"
            )
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool, token: String) -> URLRequest? {
        guard let url = URL(string: GlobalConstants.baseApiURL + "photos/\(photoId)/like") else {
            Logger.shared.log(
                method: "makeChangeLikeRequest",
                error: "Failed to create URL for photo like",
                parameter: photoId
            )
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        
        return request
    }
    
    private func getPhoto(from response: PhotoResponseBody) -> Photo {
        Photo(
            id: response.id,
            width: response.width,
            height: response.height,
            createdAt: response.createdAt,
            description: response.description,
            isLiked: response.likedByUser,
            urls: PhotoUrl(
                small: response.urls.small,
                full: response.urls.full
            )
        )
    }
    
    private func postImagesListNotification(photos: [Photo]) {
        NotificationCenter.default.post(
            name: ImagesListServiceConstants.didChangeNotification,
            object: self,
            userInfo: ["Photos": photos]
        )
    }
}
