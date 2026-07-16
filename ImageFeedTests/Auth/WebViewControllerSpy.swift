//
//  WebViewControllerSpy.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
@testable import ImageFeed
import Foundation

final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var didLoadCalled: Bool = false
    
    func load(request: URLRequest) {
        didLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
