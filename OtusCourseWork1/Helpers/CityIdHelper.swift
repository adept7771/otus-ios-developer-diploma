//
//  CityIdHelper.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

final class CityIdHelper {

    static let shared = CityIdHelper()

    private init() {}

    func compareLocations(location: Result<[Location], NetworkError>) -> [Location] {
        switch location {
        case .success(let locations):
            var filteredLocations = [Location]()

            for location in locations {
                let (mappedName, mappedCountry) = CityNameMapping.getCurrentNameAndCountry(for: location.name)
                if location.name == mappedName && location.country == mappedCountry {
                    filteredLocations.append(location)
                }
            }

            return filteredLocations

        case .failure:
            // Return an empty array if there is an error
            return []
        }
    }
}

