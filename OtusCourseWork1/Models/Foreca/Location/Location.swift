//
//  Location.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct Location: Codable {
    var id: Int
    var name: String
    var country: String
    var timezone: String
    var language: String
    var adminArea: String
    var adminArea2: String?
    var adminArea3: String?
    var lon: Double
    var lat: Double

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
        case timezone
        case language
        case adminArea = "adminArea"
        case adminArea2 = "adminArea2"
        case adminArea3 = "adminArea3"
        case lon
        case lat
    }

    init(id: Int = 0, name: String = "", country: String = "", timezone: String = "", language: String = "", adminArea: String = "", adminArea2: String? = nil, adminArea3: String? = nil, lon: Double = 0.0, lat: Double = 0.0) {
        self.id = id
        self.name = name
        self.country = country
        self.timezone = timezone
        self.language = language
        self.adminArea = adminArea
        self.adminArea2 = adminArea2
        self.adminArea3 = adminArea3
        self.lon = lon
        self.lat = lat
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        timezone = try container.decode(String.self, forKey: .timezone)
        language = try container.decode(String.self, forKey: .language)
        adminArea = try container.decode(String.self, forKey: .adminArea)
        adminArea2 = try container.decodeIfPresent(String.self, forKey: .adminArea2)
        adminArea3 = try container.decodeIfPresent(String.self, forKey: .adminArea3)
        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(language, forKey: .language)
        try container.encode(adminArea, forKey: .adminArea)
        try container.encodeIfPresent(adminArea2, forKey: .adminArea2)
        try container.encodeIfPresent(adminArea3, forKey: .adminArea3)
        try container.encode(lon, forKey: .lon)
        try container.encode(lat, forKey: .lat)
    }
}
