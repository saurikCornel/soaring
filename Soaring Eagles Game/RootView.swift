import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: NavGuard = NavGuard.shared
    var body: some View {
        switch nav.currentScreen {
                                        
        case .MENU:
            MenuView()
            
        case .LOADING:
            LoadingScreen()
            
        case .SETTINGS:
            SettingsView()
            
            
        case .STYLE:
            StyleView()
            
            
        case .ACHIVE:
            AchiveView()
            
        case .GAME:
            MainGame()
            
        case .LEVELS:
            LevelsScreen()
        }

    }
}
