import Foundation

struct ApiHandler {

    let apiUrl = "https://api.thecatapi.com/v1/images/search?limit=10"

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

//    @discardableResult
//    func getCatImages() async -> Result<[CatImage], NetworkError> {
//        var catImages: [CatImage]
//
//        do {
//            let endpointAddress = apiUrl
//
//            print("Sending get to >>> \(endpointAddress)")
//            var urlRequest = URLRequest(url: URL(string: endpointAddress)!)
//
//            urlRequest.httpMethod = "GET"
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//            print("Data: \(data) \n\n Response: \(response)")
//
//            catImages = try JSONDecoder().decode([CatImage].self, from: data)
//
//        } catch {
//            print("Error: \(error)")
//            return .failure(.networkError)
//        }
//
//        print(catImages)
//
//        return .success(catImages)
//    }
}
