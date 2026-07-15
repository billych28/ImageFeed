//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var fetchNextPageCalled = false
    
    func fetchNextPage() {
        fetchNextPageCalled = true
    }
    
    func changeLike(id: String, isLiked: Bool, onSuccess: @escaping () -> Void) {}
    
    func getPhotos() -> [ImageFeed.Photo] {
        return []
    }
    
}
