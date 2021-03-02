//
//  LoginResponse.swift
//  SocialLean
//
//  Created by Alan Ostanik on 27/02/2021.
//

import Foundation

public protocol LoginResponse {
    var scopes: [String] {get}
    var state: String {get}

    init(from url: URL) throws
}
