import SwiftUI

struct MenuView: View {
    

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    VStack(spacing: -30) {
                            
                            Spacer()
                            
                            HStack(spacing: 15)  {
                                ButtonTemplateBig(image: "playBtn", action: {NavGuard.shared.currentScreen = .LEVELS})
                                ButtonTemplateBig(image: "styleBtn", action: {NavGuard.shared.currentScreen = .STYLE})
                            }
                            
                            HStack(spacing: 15)  {
                                ButtonTemplateBig(image: "achievementsBtn", action: {NavGuard.shared.currentScreen = .ACHIVE})
                                ButtonTemplateBig(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .SETTINGS})
                            }
                        }
                        .padding(.top, 220)
                    
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .overlay(
                ZStack {
                    if isLandscape {
                        HStack {
                            BalanceTemplate()
                        }
                        .position(x: geometry.size.width / 1.2, y: geometry.size.height / 9)
                    } else {
                        BalanceTemplate()
                            .position(x: geometry.size.width / 1.3, y: geometry.size.height / 9)
                    }
                }
            )

        }
    }
}




struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    var body: some View {
        ZStack {
            Image("balanceTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                            Text("\(coinscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 80, y: 35)
                        
                    }
                )
        }
    }
}


struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 140)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}

