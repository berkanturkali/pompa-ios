import SDWebImage
import SDWebImageSVGCoder
import SwiftUI

@main
struct PompaApp: App {
    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(PompaColors.Button.filledPrimaryBackground)
        }
    }
}
