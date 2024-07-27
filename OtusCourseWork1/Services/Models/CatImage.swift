//
//  CatImage.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 27.07.2024.
//

import Foundation

import Foundation

struct CatImage: Codable {
    var id: String
    var url: String
    var width: Int
    var height: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case width
        case height
    }

    init(id: String = "", url: String = "", width: Int = 0, height: Int = 0) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }
}
