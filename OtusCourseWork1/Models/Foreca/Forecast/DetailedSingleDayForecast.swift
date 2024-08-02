//
//  DetailedSingleDayForecast.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 02.08.2024.
//

import Foundation

struct DetailedSingleDayForecast: Codable {
    
    let current: CurrentWeather

    struct CurrentWeather: Codable {
        let time: String
        let symbol: String
        let symbolPhrase: String
        let temperature: Int
        let feelsLikeTemp: Int
        let relHumidity: Int
        let dewPoint: Int
        let windSpeed: Int
        let windDir: Int
        let windDirString: String
        let windGust: Int
        let precipProb: Int
        let precipRate: Double
        let cloudiness: Int
        let thunderProb: Double
        let uvIndex: Int
        let pressure: Double
        let visibility: Int
    }
}
