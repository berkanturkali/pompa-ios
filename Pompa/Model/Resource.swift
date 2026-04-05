//

import Foundation

class Resource<T> {
    let data:T?
    let error: NetworkError?
    
    init(data: T?, error: NetworkError?) {
        self.data = data
        self.error = error
    }
    
    class Success: Resource {
        init (data: T? = nil) {
            super.init(
                data: data,
                error: nil
            )
        }
    }
    
    class Error: Resource {
        init (error: NetworkError) {
            super.init(
                data: nil,
                error: error
            )
        }
    }
    
    class Loading: Resource {
        init (data: T? = nil) {
            super.init(
                data: data,
                error: nil
            )
        }
    }
    
}
