//
//  SocialLogin.swift
//  Pods-SocialLean_Example
//
//  Created by Alan Ostanik on 27/02/2021.
//

import Foundation
import AuthenticationServices

typealias Completion<T: LoginResponse> = (Result<T, Error>) -> Void
@available(iOS 13.0, *)
typealias Context = ASWebAuthenticationPresentationContextProviding
typealias Session = ASWebAuthenticationSession

protocol SocialLogin {
    var callbackURLScheme: String {get}
    var scheme: String {get}
    var host: String {get}
    var path: String {get}
}

extension SocialLogin {

    func url(queryItems: [URLQueryItem]) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw LoginError.invalidURL
        }

        return url
    }

    func performLogin<T>(url: URL, completion: @escaping Completion<T>) {

        do {

            let session: ASWebAuthenticationSession = try self.performLogin(url, completion)
            session.start()

        } catch {

            completion(.failure(error))
        }
    }

    @available(iOS 13.0, *)
    func performLogin<T>(url: URL, context: Context, completion: @escaping Completion<T>) {

        do {

            let session: ASWebAuthenticationSession = try self.performLogin(url, completion)
            session.prefersEphemeralWebBrowserSession = true
            session.presentationContextProvider = context
            session.start()

        } catch {

            completion(.failure(error))
        }
    }

    private func performLogin<T>(_ url: URL, _ completion: @escaping Completion<T>) throws -> Session {

        let session = Session(url: url, callbackURLScheme: callbackURLScheme) { (url, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            guard let url = url else {
                completion(.failure(LoginError.emptyURLResponse))
                return
            }

            do {
                let response = try T.init(from: url)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }

        return session
    }
}
