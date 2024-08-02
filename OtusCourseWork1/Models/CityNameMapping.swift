//
//  CityNameMatching.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

/// Из апи часто прилетают названия городов которые были хз в каких годах. По идее здесь можно замаппить основные. Я привел пример питера. Он из апишки прилетает как Ленинград O_o
struct CityNameMapping {
    static let cityMappings: [String: (String, String)] = [
        "Leningrad": ("Saint Petersburg", "Russia"),

    ]

    static func getCurrentNameAndCountry(for apiCityName: String) -> (String, String)? {
        return cityMappings[apiCityName]
    }
}


