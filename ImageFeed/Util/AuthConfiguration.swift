//
//  Constants.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.05.2026.
//

private enum Constants {
    // MARK: - API
    static let defaultBaseURLString: String = "https://unsplash.com"
    static let accessKey: String = "Gll7I_bHpQYaaQx03TMwIJoG3CED6zwJGPuvDWavsnc"
    static let secretKey: String = "qcJz_aiavyy3YvgeGhFMQh_kAm65nS0Sdy_xXi9gKB0"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURLString: Constants.defaultBaseURLString,
        )
    }
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURLString: String,
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.authURLString = authURLString
    }
}
