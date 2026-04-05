//

import Foundation

struct ProvinceService {
    
    private var networkManager = NetworkManager.shared
    
    static let shared = ProvinceService()
    
    private init() {}
    
    private let provincesUrl = "province/all"
    
    func getProvinces() async throws -> Resource<[Province]> {
        
        let url = ApiConfig.url(provincesUrl)
        
        do {
            let response: Resource<[Province]> = try await networkManager.request(to: url, method: .GET)
            
            return response
        } catch {
            throw error
        }
    }
    
}
