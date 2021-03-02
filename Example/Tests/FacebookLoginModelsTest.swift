//
//  FacebookLoginModelsTest.swift
//  SocialLean_Tests
//
//  Created by Alan Ostanik on 25/02/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import SocialLean

class FacebookLoginModelsTest: XCTestCase {

    let baseURL = "fb818311075425817://authorize/"
    let grantedScope = "granted_scopes=email%2Cpublic_profile"
    let state = "state=A592B6D4-513D-408A-B00E-CD2D0FF7F635"
    let deniedScope = "denied_scopes="
    let accessToken = "access_token=123321123"
    let code = "code=AQC3BNEnjkt0Z"
    let expiration = "data_access_expiration_time=162204000"
    let expires = "expires_in=5107578"

    func testFacebookResponseToken() throws {
        let fragments = [accessToken, expiration, expires, deniedScope, grantedScope, state]
            .joined(separator: "&")
        let stringURL = baseURL + "#" + fragments
        let url = URL(string: stringURL)
        let response = try FacebookLogin.ResponseToken(from: url!)
        assert(response,
               scopes: ["email", "public_profile"],
               accessToken: "123321123",
               state: "A592B6D4-513D-408A-B00E-CD2D0FF7F635")
    }

    func testFacebookResponseTokenErrorToken() throws {
        let queryItems = [expiration, expires, deniedScope, grantedScope, state].joined(separator: "&")
        let stringURL = baseURL + "#" + queryItems
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseToken(from: url!),
                   errorDescription: "There is some error in response serialization: token not found")
    }

    func testFacebookResponseTokenErrorState() throws {
        let queryItems = [accessToken, expiration, expires, deniedScope, grantedScope].joined(separator: "&")
        let stringURL = baseURL + "#" + queryItems
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseToken(from: url!),
                   errorDescription: "There is some error in response serialization: state not found")
    }

    func testFacebookResponseTokenErrorScope() throws {
        let queryItems = [accessToken, expiration, expires, deniedScope, state].joined(separator: "&")
        let stringURL = baseURL + "#" + queryItems
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseToken(from: url!),
                   errorDescription: "There is some error in response serialization: granted_scopes not found")
    }

    func testFacebookResponseTokenErrorNoFragment() throws {
        let stringURL = baseURL
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseToken(from: url!),
                   errorDescription: "There is some error in response serialization: Unable to find fragment")
    }

    func testFacebookResponseTokenErrorNoComponent() throws {
        let url = URL(string: "http://example.com:-80/")
        let errorDescription = "ErrorDescription: Unable to find components"
        let errorTitle = "Ther is some issue handling this url: http://example.com:-80/\n"
        try assert(try FacebookLogin.ResponseToken(from: url!),
                   errorDescription: errorTitle + errorDescription)
    }

    func testFacebookResponseCode() throws {
        let queryItems = [code, deniedScope, grantedScope, state].joined(separator: "&")
        let stringURL = baseURL + "?" + queryItems
        let url = URL(string: stringURL)
        let response = try FacebookLogin.ResponseCode(from: url!)
        assert(response,
               scopes: ["email", "public_profile"],
               code: "AQC3BNEnjkt0Z",
               state: "A592B6D4-513D-408A-B00E-CD2D0FF7F635")
    }

    func testFacebookResponseCodeErrorCode() throws {
        let queryItems = [deniedScope, grantedScope, state].joined(separator: "&")
        let stringURL = baseURL + "?" + queryItems
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseCode(from: url!),
                   errorDescription: "There is some error in response serialization: code not found")
    }

    func testFacebookResponseCodeErrorState() throws {
        let queryItems = [code, deniedScope, grantedScope].joined(separator: "&")
        let stringURL = baseURL + "?" + queryItems
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseCode(from: url!),
                   errorDescription: "There is some error in response serialization: state not found")
    }

    func testFacebookResponseCodeErrorScope() throws {
        let queryItems = [code, deniedScope, state].joined(separator: "&")
        let stringURL = baseURL + "?" + queryItems
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseCode(from: url!),
                   errorDescription: "There is some error in response serialization: granted_scopes not found")
    }

    func testFacebookResponseCodeErrorNoQuery() throws {
        let stringURL = baseURL
        let url = URL(string: stringURL)

        try assert(try FacebookLogin.ResponseCode(from: url!),
                   errorDescription: "There is some error in response serialization: Unable to find queryItems")
    }

    func testFacebookResponseCodeErrorNoComponent() throws {
        let url = URL(string: "http://example.com:-80/")
        let errorDescription = "ErrorDescription: Unable to find components"
        let errorTitle = "Ther is some issue handling this url: http://example.com:-80/\n"
        try assert(try FacebookLogin.ResponseToken(from: url!),
                   errorDescription: errorTitle + errorDescription)
    }
}

extension FacebookLoginModelsTest {

    func assert(_ response: FacebookLogin.ResponseToken,
                scopes: [String],
                accessToken: String,
                state: String,
                file: StaticString = #file,
                line: UInt = #line) {

        XCTAssertEqual(response.token, accessToken)
        XCTAssertEqual(response.state, state)
        XCTAssertEqual(response.scopes, scopes)
    }

    func assert(_ response: FacebookLogin.ResponseCode,
                scopes: [String],
                code: String,
                state: String,
                file: StaticString = #file,
                line: UInt = #line) {

        XCTAssertEqual(response.code, code)
        XCTAssertEqual(response.state, state)
        XCTAssertEqual(response.scopes, scopes)
    }

    func assert<T>(_ expression: @autoclosure () throws -> T,
                   errorDescription: String,
                   in file: StaticString = #file,
                   line: UInt = #line) throws {

        var thrownError: Error?
        XCTAssertThrowsError(try expression()) { thrownError = $0 }
        let error = try XCTUnwrap(thrownError as? LoginError)
        XCTAssertEqual(error.errorDescription, errorDescription)
    }
}
