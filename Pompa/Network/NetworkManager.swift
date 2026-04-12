//

import Foundation


struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    func request<U: Codable>(
        to url: String,
        method: HttpMethod,
        responseType: BaseApiResponse<U>.Type = BaseApiResponse<U>.self
    ) async throws -> Resource<U> {
        try await request(
            to: url,
            method: method,
            body: Optional<EmptyRequestBody>.none,
            responseType: responseType
        )
    }
    
    func request<T: Encodable, U: Codable>(
        to url: String,
        method: HttpMethod,
        body: T? = nil,
        responseType: BaseApiResponse<U>.Type = BaseApiResponse<U>.self
    ) async throws -> Resource<U> {
        
        guard let url = URL(string: url) else {
            throw NetworkError.badURL(url)
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let body = body {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(body)
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                throw NetworkError.unknownError(statusCode: statusCode, description: LocalizedStrings.somethingWentWrong)
            }
            
            guard !data.isEmpty else {
                throw NetworkError.unknownError(statusCode: httpResponse.statusCode, description: LocalizedStrings.noResultFound)
            }
            
            let decodedResponse: BaseApiResponse<U>
            do {
                decodedResponse = try JSONDecoder().decode(responseType, from: data)
            } catch let decodingError as DecodingError {
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("RAW RESPONSE:")
                    print(rawResponse)
                }

                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("DECODING ERROR - Missing key:", key.stringValue, context.debugDescription)
                case .typeMismatch(let type, let context):
                    print("DECODING ERROR - Type mismatch:", type, context.debugDescription)
                    print("CODING PATH:", context.codingPath.map(\.stringValue).joined(separator: "."))
                case .valueNotFound(let type, let context):
                    print("DECODING ERROR - Value not found:", type, context.debugDescription)
                case .dataCorrupted(let context):
                    print("DECODING ERROR - Data corrupted:", context.debugDescription)
                @unknown default:
                    print("DECODING ERROR:", decodingError)
                }

                throw decodingError
            }
            
            print("decoded response = \(decodedResponse)")
            
            guard decodedResponse.success else {
                throw NetworkError.unknownError(statusCode: httpResponse.statusCode, description: LocalizedStrings.somethingWentWrong)
            }
            
            guard let data = decodedResponse.data else {
                throw NetworkError.unknownError(statusCode: httpResponse.statusCode, description: LocalizedStrings.somethingWentWrong)
            }
            
            return Resource.Success(data: data)
        } catch let error {
            print(error.localizedDescription)
            return Resource.Error(error: handleError(error, url: url.absoluteString))
        }
    
}

private struct EmptyRequestBody: Encodable {}
    
    private func handleError(_ error: Error, url: String) -> NetworkError {
        if let urlError = error as? URLError {
            return mapURLError(urlError, url: url)
        }
        
        if error is DecodingError {
            return NetworkError.decodingError(error)
        }
        
        return NetworkError.unknownError(statusCode: 500, description: LocalizedStrings.somethingWentWrong)
    }
    
    private func mapURLError(_ error: URLError, url: String) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet:
            return .notConnectedToInternet(LocalizedStrings.checkYourConnection)
        case .timedOut:
            return .timeOut(LocalizedStrings.timeout)
        case .cannotFindHost:
            return .cannotConnectToHost(String(format: LocalizedStrings.canNotConnectToHost, url))
        default:
            return .requestFailed(error.localizedDescription)
        }
    }
    
    func handleNetworkError(_ error: NetworkError) -> String {
        switch error {
        case .badURL(let message),
                .requestFailed(let message),
                .notConnectedToInternet(let message),
                .timeOut(let message),
                .cannotConnectToHost(let message):
            return message
        case .decodingError(let underlyingError):
            return underlyingError.localizedDescription
        case .httpError(_, let localizedDescription),
                .unknownError(_, let localizedDescription):
            return localizedDescription
        }
    }
}
