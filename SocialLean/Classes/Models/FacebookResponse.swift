//
//  FacebookResponse.swift
//  SocialLean
//
//  Created by Alan Ostanik on 24/02/2021.
//

import Foundation

public protocol FacebookResponse: LoginResponse { }

extension FacebookResponse {

    static func components(from url: URL) throws -> URLComponents {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw LoginError.urlHandling(url: url.absoluteString,
                                                 description: "Unable to find components")
        }

        return components
    }

    static func queryItems(from components: URLComponents) throws -> [URLQueryItem] {

        guard let queryItems = components.queryItems else {
            throw LoginError.invalidFacebookResponse(description: "Unable to find queryItems")
        }

        return queryItems
    }

    static func fragments(from components: URLComponents) throws -> [String: String] {

        guard let fragment = components.fragment else {
            throw LoginError.invalidFacebookResponse(description: "Unable to find fragment")
        }

        let dictionary:[String: String] = fragment
            .components(separatedBy: "&")
            .compactMap { element -> [String: String]? in
                let component = element.components(separatedBy:"=")
                guard component.count == 2 else { return nil }
                return [component[0]: component[1]]
            }
            .reduce([String: String]()) { (result, dict) in
                var temp = result
                temp.merge(dict)  { (_, new) in new }
                return temp
            }
        return dictionary
    }
}
