//
//  CityNameMatching.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct CityNameMapping {

    static let cityMappings: [String: (newName: String, country: String)] = [
        "Leningrad": ("Saint Petersburg", "Russia"),
        
    ]

    static func getCurrentNameAndCountry(for apiCityName: String) -> (String, String) {
        let mapping = cityMappings[apiCityName] ?? (apiCityName, "")
        return (mapping.newName, mapping.country)
    }
}

