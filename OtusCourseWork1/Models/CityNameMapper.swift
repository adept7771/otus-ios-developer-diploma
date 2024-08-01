//
//  CityNameMatching.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct CityNameMapper {

    static let cityMappings: [String: String] = [
        "Leningrad": "Saint Petersburg",

    ]

    static func getCurrentName(for apiCityName: String) -> String {
        return cityMappings[apiCityName] ?? apiCityName
    }
}
