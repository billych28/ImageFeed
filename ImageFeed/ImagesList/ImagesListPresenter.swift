//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func fetchNextPage()
    func changeLike(id: String, isLiked: Bool, onSuccess: @escaping () -> Void)
    func getPhotos() -> [Photo]
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private var isLoading: Bool = false
    private let imagesListService = ImagesListService.shared
    
    func fetchNextPage() {
        guard !isLoading else { return }
        isLoading = true
        
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
        
            isLoading = false
            
            switch result {
            case .success:
                view?.updateTableViewAnimated()
            case .failure(let error):
                view?.onFetchFailed(with: error)
            }
        }
    }
    
    func changeLike(id: String, isLiked: Bool, onSuccess: @escaping () -> Void) {
        imagesListService
            .changeLike(photoId: id, isLike: !isLiked) { [weak self] result in
                guard let self else { return }
            
                defer { view?.showProgress(isShowing: false) }
                
                switch result {
                case .success:
                    onSuccess()
                case .failure(let error):
                    view?.onFetchFailed(with: error)
                }
            }
    }
    
    func getPhotos() -> [Photo] {
        imagesListService.photos
    }
}
