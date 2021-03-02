//
//  FacebookLogin.swift
//  Lean
//
//  Created by Alan Ostanik on 23/02/2021.
//

import Foundation
import AuthenticationServices

public class FacebookLogin: NSObject, SocialLogin {

    public typealias Completion<T: FacebookResponse> = (Result<T, Error>) -> Void

    private let facebookAppID: String
    private let scopes: [Scopes]
    private var state: String { UUID().uuidString }
    let callbackURLScheme: String
    var scheme = "https"
    var host = "www.facebook.com"
    var path = "/v7.0/dialog/oauth"

    public init(facebookAppID: String, scopes: Scopes..., callbackScheme: String? = nil) {
        self.facebookAppID = facebookAppID
        self.scopes = scopes

        if callbackScheme != nil  {
            self.callbackURLScheme = callbackScheme!
        } else {
            self.callbackURLScheme = "fb\(facebookAppID)://authorize"
        }

        super.init()
    }

    public func performLogin<T>(completion: @escaping Completion<T>) {
        do {
            let url = try self.url(queryItems: queryItems(for: T.self))
            self.performLogin(url: url, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    @available(iOS 13.0, *)
    public func performLogin<T>(context: ASWebAuthenticationPresentationContextProviding,
                                completion: @escaping Completion<T>) {
        do {
            let url = try self.url(queryItems: queryItems(for: T.self))
            self.performLogin(url: url, context: context, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    private func queryItems<T: FacebookResponse>(for type: T.Type) -> [URLQueryItem] {
        [
            URLQueryItem(name: "client_id", value: facebookAppID),
            URLQueryItem(name: "redirect_uri", value: callbackURLScheme),
            URLQueryItem(name: "scope", value: scopes.map {$0.rawValue}.joined(separator: ",")),
            URLQueryItem(name: "response_type", value: "\(responseType(for: T.self)) granted_scopes"),
            URLQueryItem(name: "state", value: state)
        ]
    }

    private func responseType<T: FacebookResponse>(for type: T.Type) -> String {
        switch type.self {
        case is ResponseToken.Type:
            return "token"
        case is ResponseCode.Type:
            return "code"
        default:
            return ""
        }
    }
}
