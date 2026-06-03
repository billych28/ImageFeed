//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 20.05.2026.
//

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}
