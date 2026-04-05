//

import SwiftUI

struct ContentView: View {
    @StateObject private var pompaUserPrefs = PompaUserPrefs.shared

    var body: some View {
        Group {
            if pompaUserPrefs.hasSelectedProvinceAndFavoriteProvider() {
                Text("Home")
            } else {
                ProvincesScreen()
            }
        }
    }
}

#Preview {
    ContentView()
}
