//
//  ApplicationError.swift
//  Lean
//
//  Created by Alan Ostanik on 23/02/2021.
//

import Foundation

enum AppError: Error {

    case fileNotFound
    case unableToCast(fromType: String)
}
