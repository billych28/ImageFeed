//
//  Constants.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.05.2026.
//

enum GlobalConstants {
    // MARK: - API
    static let defaultBaseURLString: String = "https://unsplash.com"
    static let accessKey: String = "Gll7I_bHpQYaaQx03TMwIJoG3CED6zwJGPuvDWavsnc"
    static let secretKey: String = "qcJz_aiavyy3YvgeGhFMQh_kAm65nS0Sdy_xXi9gKB0"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    // MARK: - Segue Identifier
    static let showWebViewSegueIdentifier = "ShowWebView"
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
    static let showAuthenticationSegueIdentifier = "ShowAuthentication"
}
