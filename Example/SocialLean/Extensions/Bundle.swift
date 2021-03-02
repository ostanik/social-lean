//
//  Bundle.swift
//  Lean
//
//  Created by Alan Ostanik on 23/02/2021.
//

import Foundation

extension Bundle {

    func loadInfoPlist() throws -> NSDictionary {

        guard let filePath = self.path(forResource: "Info", ofType: "plist") else {
            throw AppError.fileNotFound
        }

        guard let dictionary = NSDictionary(contentsOfFile: filePath) else {
            throw AppError.unableToCast(fromType: "NSDictionary")
        }

        return dictionary
    }
}
