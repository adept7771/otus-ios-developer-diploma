import Foundation

final class ApiHandlerForeca {

    static let shared = ApiHandlerForeca()

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
        return await fetchAuthToken().map { token in
            self.authToken = token
        }
    }

    private func fetchAuthToken() async -> Result<String, NetworkError> {
        let endpointAddress = "\(authUrl)/token?expire_hours=5"
        var urlRequest = URLRequest(url: URL(string: endpointAddress)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "user=\(apiUser)&password=\(apiP)".data(using: .utf8)

        return await performRequest(urlRequest, decodeType: AuthResponse.self)
            .map { $0.accessToken }
    }

    private func performRequest<T: Decodable>(_ request: URLRequest, decodeType: T.Type) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return .failure(.networkError)
            }
            let decodedResponse = try decoder.decode(T.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(.networkError)
        }
    }

    @discardableResult
    private func searchCityInForecaLocationsBase(locationName: String) async -> Result<LocationList, NetworkError> {
        let ensureTokenResult = await ensureAuthToken()
        guard case .success = ensureTokenResult else { return .failure(.networkError) }

        var urlRequest = URLRequest(url: URL(string: "\(apiUrl)/location/search/\(locationName)?lang=en")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")

        return await performRequest(urlRequest, decodeType: LocationList.self)
    }

    @discardableResult
    func fetchCityFromForecaLocationsBase(for locationName: String) async -> Result<[Location], NetworkError> {
        return await searchCityInForecaLocationsBase(locationName: locationName)
            .map { $0.locations }
    }

    func extractLocations(from result: Result<[Location], NetworkError>) -> [Location] {
        return result.getOrDefault([])
    }

    @discardableResult
    func getDetailedSingleDayForecast(zoneId: Int) async -> DetailedSingleDayForecast {
        let ensureTokenResult = await ensureAuthToken()
        guard case .success = ensureTokenResult else { return DetailedSingleDayForecast() }

        var urlRequest = URLRequest(url: URL(string: "\(apiUrl)/current/\(zoneId)")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")

        return await performRequest(urlRequest, decodeType: DetailedSingleDayForecast.self)
            .getOrDefault(DetailedSingleDayForecast())
    }

    @discardableResult
    func getWeeklyForecast(zoneId: Int) async -> [WeeklySingleDay] {
        let ensureTokenResult = await ensureAuthToken()
        guard case .success = ensureTokenResult else { return [] }

        var urlRequest = URLRequest(url: URL(string: "\(apiUrl)/forecast/daily/\(zoneId)")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(authToken ?? "")", forHTTPHeaderField: "Authorization")

        let result: Result<WeeklyForecast, NetworkError> = await performRequest(urlRequest, decodeType: WeeklyForecast.self)

        switch result {
        case .success(let weeklyForecast):
            return weeklyForecast.forecast
        case .failure:
            return []
        }
    }
}

extension Result {
    func getOrDefault(_ defaultValue: Success) -> Success {
        switch self {
        case .success(let value): return value
        case .failure: return defaultValue
        }
    }
}
