//
//  DetailedSingleDayForecast.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 02.08.2024.
//

import Foundation

struct DetailedSingleDayForecast: Codable {
    var current: CurrentWeather

    struct CurrentWeather: Codable {
        var time: String
        var symbol: String
        var symbolPhrase: String
        var temperature: Int
        var feelsLikeTemp: Int
        var relHumidity: Int
        var dewPoint: Int
        var windSpeed: Int
        var windDir: Int
        var windDirString: String
        var windGust: Int
        var precipProb: Int
        var precipRate: Double
        var cloudiness: Int
        var thunderProb: Double
        var uvIndex: Int
        var pressure: Double
        var visibility: Int

        private enum CodingKeys: String, CodingKey {
            case time
            case symbol
            case symbolPhrase
            case temperature
            case feelsLikeTemp
            case relHumidity
            case dewPoint
            case windSpeed
            case windDir
            case windDirString
            case windGust
            case precipProb
            case precipRate
            case cloudiness
            case thunderProb
            case uvIndex
            case pressure
            case visibility
        }

        init(time: String = "", symbol: String = "", symbolPhrase: String = "", temperature: Int = 0, feelsLikeTemp: Int = 0, relHumidity: Int = 0, dewPoint: Int = 0, windSpeed: Int = 0, windDir: Int = 0, windDirString: String = "", windGust: Int = 0, precipProb: Int = 0, precipRate: Double = 0.0, cloudiness: Int = 0, thunderProb: Double = 0.0, uvIndex: Int = 0, pressure: Double = 0.0, visibility: Int = 0) {
            self.time = time
            self.symbol = symbol
            self.symbolPhrase = symbolPhrase
            self.temperature = temperature
            self.feelsLikeTemp = feelsLikeTemp
            self.relHumidity = relHumidity
            self.dewPoint = dewPoint
            self.windSpeed = windSpeed
            self.windDir = windDir
            self.windDirString = windDirString
            self.windGust = windGust
            self.precipProb = precipProb
            self.precipRate = precipRate
            self.cloudiness = cloudiness
            self.thunderProb = thunderProb
            self.uvIndex = uvIndex
            self.pressure = pressure
            self.visibility = visibility
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            time = try container.decode(String.self, forKey: .time)
            symbol = try container.decode(String.self, forKey: .symbol)
            symbolPhrase = try container.decode(String.self, forKey: .symbolPhrase)
            temperature = try container.decode(Int.self, forKey: .temperature)
            feelsLikeTemp = try container.decode(Int.self, forKey: .feelsLikeTemp)
            relHumidity = try container.decode(Int.self, forKey: .relHumidity)
            dewPoint = try container.decode(Int.self, forKey: .dewPoint)
            windSpeed = try container.decode(Int.self, forKey: .windSpeed)
            windDir = try container.decode(Int.self, forKey: .windDir)
            windDirString = try container.decode(String.self, forKey: .windDirString)
            windGust = try container.decode(Int.self, forKey: .windGust)
            precipProb = try container.decode(Int.self, forKey: .precipProb)
            precipRate = try container.decode(Double.self, forKey: .precipRate)
            cloudiness = try container.decode(Int.self, forKey: .cloudiness)
            thunderProb = try container.decode(Double.self, forKey: .thunderProb)
            uvIndex = try container.decode(Int.self, forKey: .uvIndex)
            pressure = try container.decode(Double.self, forKey: .pressure)
            visibility = try container.decode(Int.self, forKey: .visibility)
        }
    }

    // Default initializer
    init(current: CurrentWeather = CurrentWeather()) {
        self.current = current
    }
}

