//
//  NetworkError.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 27.07.2024.
//

import Foundation

enum NetworkError: Error {
    case customError(String)
    case emptyData
    case wrongJson
    case serverError
    case networkError
}
