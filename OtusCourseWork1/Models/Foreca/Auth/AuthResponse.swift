//
//  AuthResponse.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

struct AuthResponse: Codable {
    var accessToken: String
    var expiresIn: Int
    var tokenType: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }

    init(accessToken: String = "", expiresIn: Int = 0, tokenType: String = "") {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        tokenType = try container.decode(String.self, forKey: .tokenType)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(expiresIn, forKey: .expiresIn)
        try container.encode(tokenType, forKey: .tokenType)
    }
}
