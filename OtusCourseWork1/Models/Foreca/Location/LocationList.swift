//
//  LocationList.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct LocationList: Codable {
    var locations: [Location]

    private enum CodingKeys: String, CodingKey {
        case locations
    }

    init(locations: [Location] = []) {
        self.locations = locations
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        locations = try container.decode([Location].self, forKey: .locations)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(locations, forKey: .locations)
    }
}
