//
//  FacebookLogin+Erros.swift
//  SocialLean
//
//  Created by Alan Ostanik on 24/02/2021.
//

import Foundation

public enum LoginError: Error {
    case emptyURLResponse
    case invalidFacebookResponse(description: String)
    case invalidURL
    case urlHandling(url: String, description: String)
}

public extension LoginError {
    var errorDescription: String? {
        switch self {
        case .emptyURLResponse:
            return "Unable to retrieve URL from the login"
        case .invalidFacebookResponse(let description):
            return "There is some error in response serialization: \(description)"
        case .invalidURL:
            return "Unable to build URL"
        case .urlHandling(let url, let description):
            return "Ther is some issue handling this url: \(url)\nErrorDescription: \(description)"
        }
    }
}
