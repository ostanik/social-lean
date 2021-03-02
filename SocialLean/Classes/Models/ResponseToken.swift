//
//  ResponseToken.swift
//  SocialLean
//
//  Created by Alan Ostanik on 25/02/2021.
//

import Foundation

extension FacebookLogin {

    public struct ResponseToken: FacebookResponse {
        private(set) public var scopes: [String]
        private(set) public var state: String

        public let token: String

        public init(from url: URL) throws {

            let component = try Self.components(from: url)
            let fragments = try Self.fragments(from: component)

            guard let state = fragments["state"] else {
                throw LoginError.invalidFacebookResponse(description: "state not found")
            }

            guard let scope = fragments["granted_scopes"] else {
                throw LoginError.invalidFacebookResponse(description: "granted_scopes not found")
            }

            guard let token = fragments["access_token"] else {
                throw LoginError.invalidFacebookResponse(description: "token not found")
            }

            self.scopes = scope.components(separatedBy: ",")
            self.state = state
            self.token = token
        }
    }
}
