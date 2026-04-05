//

import Foundation

enum NetworkError: Error {
    case badURL(String)
    case requestFailed(String)
    case decodingError(Error)
    case httpError(statusCode: Int, localizedDescription: String)
    case notConnectedToInternet(String)
    case timeOut(String)
    case cannotConnectToHost(String)
    case unknownError(statusCode: Int, description: String)
}
