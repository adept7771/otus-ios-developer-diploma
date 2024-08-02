//
//  NetworkError.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

enum NetworkError: Error {
    case customError(String)
    case emptyData
    case wrongJson
    case serverError
    case networkError
    case invalidResponse
    case decodingError
}
