//
//  FacebookViewModel.swift
//  Lean
//
//  Created by Alan Ostanik on 23/02/2021.
//

import Foundation
import AuthenticationServices
import SocialLean

class FacebookViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {

    enum State {
        case none
        case failed(Error)
        case logged(String)
        case canceled
    }

    @Published var state = State.none

    private lazy var key: String = {
        let plist = try? Bundle.main.loadInfoPlist()
        let key = plist?.object(forKey: "FacebookAppID") as? String
        return key ?? ""
    }()

    func performLogin() {
        FacebookLogin(facebookAppID: key, scopes: .email)
            .performLogin(context: self) { [weak self] (result: Result<FacebookLogin.ResponseCode, Error>) in
                switch result {
                case .success(let response):
                    self?.state = .logged(response.code)
                case .failure(let error):
                    switch error {
                    case ASWebAuthenticationSessionError.canceledLogin:
                        self?.state = .canceled
                    default:
                        self?.state = .failed(error)
                    }
                }
            }
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
