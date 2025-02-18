import SwiftUI

struct LevelsScreen: View {
    @AppStorage("isCanSpin") var isCanSpin: Bool = true
    @AppStorage("level") var level: Int = 1 // Переменная для хранения текущего уровня
    
    // Массив с именами изображений для уровней
    let levelImages: [String] = Array(1...10).map { "\($0)" }
    
    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                                Spacer()
                                BalanceTemplate()
                            }
                            Spacer()
                        }
                        
                        Image(.stylePlate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 380, height: 380)
                        
                        // Добавляем сетку с уровнями
                        VStack(spacing: 5) { // Вертикальное расстояние между рядами
                            ForEach(0..<2, id: \.self) { row in // 4 ряда
                                HStack(spacing: 5) { // Горизонтальное расстояние между элементами
                                    ForEach(0..<5, id: \.self) { col in
                                        let index = row * 5 + col
                                        if index < levelImages.count {
                                            let imageName = levelImages[index]
                                            Image(imageName)
                                                .resizable()
                                                .frame(width: 55, height: 55) // Размер 45x45 пикселей
                                                .scaledToFill()
                                                .overlay(
                                                    Group {
                                                        if index >= level {
                                                            Color.black.opacity(0.5) // Затемняем недоступные уровни
                                                        }
                                                    }
                                                )
                                                .onTapGesture {
                                                    if index < level {
                                                        // Переход на MainGame при нажатии на доступный уровень
                                                        NavGuard.shared.currentScreen = .GAME
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
//                        .padding(.top, 5) // Дополнительный отступ вокруг сетки
                    }
                    
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
                Image(.backgroundLevels) // Убедитесь, что у вас есть изображение backgroundMenu
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

#Preview {
    LevelsScreen()
}
