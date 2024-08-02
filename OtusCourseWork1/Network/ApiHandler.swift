import Foundation

final class ApiHandler {

    static let shared = ApiHandler()

    private let baseUrl = "https://pfa.foreca.com/"
    private var apiUrl: String { return baseUrl + "api/v1" }
    private var authUrl: String { return baseUrl + "authorize" }
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private let apiUser = "metallfun"
    private let apiP = "LySTATsE3wHD"

    private(set) var authToken: String?

    private init() { }

    private func ensureAuthToken() async -> Result<Void, NetworkError> {
        if let token = authToken, !token.isEmpty {
            return .success(())
        }

        switch await fetchAuthToken() {
        case .success(let token):
            self.authToken = token
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    @discardableResult
    private func getAuthToken() async -> Result<String, NetworkError> {
        do {
            let endpointAddress = "\(authUrl)/token?expire_hours=5"

            print("\n Sending getAuthToken request to >>> \(endpointAddress) \n")
            var urlRequest = URLRequest(url: URL(string: endpointAddress)!)

            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            let bodyString = "user=\(apiUser)&password=\(apiP)"
            urlRequest.httpBody = bodyString.data(using: .utf8)

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Invalid response: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return .failure(.networkError)
            }

            let authResponse = try decoder.decode(AuthResponse.self, from: data)

            return .success(authResponse.accessToken)

        } catch {
            print("Error: \(error)")
            return .failure(.networkError)
        }
    }

    private func fetchAuthToken() async -> Result<String, NetworkError> {
        switch await getAuthToken() {
        case .success(let token):
            print("\n Access Token: \(token) \n")
            return .success(token)
        case .failure(let error):
            print("\n Failed to fetch token (getAuthToken): \(error) \n")
            return .failure(error)
        }
    }

    @discardableResult
    private func searchCityInForecaLocationsBase(locationName: String) async -> Result<LocationList, NetworkError> {
        let ensureTokenResult = await ensureAuthToken()
        
        guard case .success = ensureTokenResult else {
            return .failure(.networkError)
        }

        do {
            let endpointAddress = "\(apiUrl)/location/search/\(locationName)?lang=en"

            print("\n Sending search Location Code request to >>> \(endpointAddress) \n")
            var urlRequest = URLRequest(url: URL(string: endpointAddress)!)

            urlRequest.httpMethod = "POST"

            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Invalid response: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return .failure(.networkError)
            }

            let decodedResponse = try decoder.decode(LocationList.self, from: data)
            return .success(decodedResponse)
        } catch {
            print("Error searchCityInForecaLocationsBase : \(error)")
            return .failure(.networkError)
        }
    }

    @discardableResult
    func fetchCityFromForecaLocationsBase(for locationName: String) async -> Result<[Location], NetworkError> {
        let result = await searchCityInForecaLocationsBase(locationName: locationName)

        switch result {
        case .success(let locationList):
            return .success(locationList.locations)

        case .failure(let error):
            print("Can't fetchCityFromForecaLocationsBase form \(locationName) + \(error)")
            return .failure(error)
        }
    }

    func extractLocations(from result: Result<[Location], NetworkError>) -> [Location] {
        switch result {
        case .success(let locations):
            return locations
        case .failure:
            print("Can't extract locations from \(result)")
            return []
        }
    }
}
