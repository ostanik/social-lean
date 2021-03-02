//
//  ResponseCode.swift
//  SocialLean
//
//  Created by Alan Ostanik on 25/02/2021.
//

import Foundation

extension FacebookLogin {

    public struct ResponseCode: FacebookResponse {
        private(set) public var scopes: [String]
        private(set) public var state: String
        public let code: String

        public init(from url: URL) throws {

            let component = try Self.components(from: url)
            let items = try Self.queryItems(from: component)

            guard let state = items.first(where: { $0.name == "state" })?.value else {
                throw LoginError.invalidFacebookResponse(description: "state not found")
            }

            guard let scope = items.first(where: { $0.name == "granted_scopes" })?.value else {
                throw LoginError.invalidFacebookResponse(description: "granted_scopes not found")
            }

            guard let code = items.first(where: { $0.name == "code" })?.value else {
                throw LoginError.invalidFacebookResponse(description: "code not found")
            }

            self.scopes = scope.components(separatedBy: ",")
            self.state = state
            self.code = code
        }
    }
}
