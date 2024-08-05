//
//  CityIdHelper.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

final class CityIdHelper {
    static let shared = CityIdHelper()

    private init() {}

    func compareLocations(result: Result<[Location], NetworkError>) -> [Location] {
        switch result {
        case .success(let incomingLocations):
            var filteredLocations = [Location]()

            for incomingLocation in incomingLocations {
                
                let incLocationName = incomingLocation.name
                let incLocationCountry = incomingLocation.country

                for (mappedOldCityName, (_, mappedCountry)) in CityNameMapping.cityMappings {
                    if incLocationName == mappedOldCityName && incLocationCountry == mappedCountry {
                        filteredLocations.append(incomingLocation)
                    }
                }
            }

            return filteredLocations

        case .failure:
            print("\n WARNING! No locations filtered after comparing with mapping locations list! Zone undefied. \n")
            return []
        }
    }
}


