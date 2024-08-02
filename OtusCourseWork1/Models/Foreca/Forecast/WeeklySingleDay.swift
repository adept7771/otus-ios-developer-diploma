//
//  DailyForecast.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct WeeklySingleDay: Codable {
    var date: String
    var symbol: String
    var maxTemp: Int
    var minTemp: Int
    var precipAccum: Double
    var maxWindSpeed: Int
    var windDir: Int

    private enum CodingKeys: String, CodingKey {
        case date
        case symbol
        case maxTemp = "maxTemp"
        case minTemp = "minTemp"
        case precipAccum = "precipAccum"
        case maxWindSpeed = "maxWindSpeed"
        case windDir = "windDir"
    }

    init(date: String = "", symbol: String = "", maxTemp: Int = 0, minTemp: Int = 0, precipAccum: Double = 0.0, maxWindSpeed: Int = 0, windDir: Int = 0) {
        self.date = date
        self.symbol = symbol
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.precipAccum = precipAccum
        self.maxWindSpeed = maxWindSpeed
        self.windDir = windDir
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        symbol = try container.decode(String.self, forKey: .symbol)
        maxTemp = try container.decode(Int.self, forKey: .maxTemp)
        minTemp = try container.decode(Int.self, forKey: .minTemp)
        precipAccum = try container.decode(Double.self, forKey: .precipAccum)
        maxWindSpeed = try container.decode(Int.self, forKey: .maxWindSpeed)
        windDir = try container.decode(Int.self, forKey: .windDir)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(maxTemp, forKey: .maxTemp)
        try container.encode(minTemp, forKey: .minTemp)
        try container.encode(precipAccum, forKey: .precipAccum)
        try container.encode(maxWindSpeed, forKey: .maxWindSpeed)
        try container.encode(windDir, forKey: .windDir)
    }
}
