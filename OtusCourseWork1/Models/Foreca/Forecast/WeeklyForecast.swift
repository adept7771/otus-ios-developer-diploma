//
//  WeeklyForecast.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct WeeklyForecast: Codable {
    var forecast: [DailyForecast]

    private enum CodingKeys: String, CodingKey {
        case forecast
    }

    init(forecast: [DailyForecast] = []) {
        self.forecast = forecast
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        forecast = try container.decode([DailyForecast].self, forKey: .forecast)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(forecast, forKey: .forecast)
    }
}

