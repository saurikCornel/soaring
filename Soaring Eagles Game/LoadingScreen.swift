import SwiftUI

struct LoadingScreen: View {
    @State private var currentWheelImageIndex = 0
    @State private var isAnimating = true
    @State private var progress: Int = 0
    @State private var isActive = false
    @State private var urlToLoad: URL?
    @AppStorage("isNeeded") private var isNeeded: Bool = false

    let wheelImages = ["frame1", "frame2", "frame3", "frame4", "frame5", "frame6", "frame7", "frame8", "frame9"]
    let animationDuration = 0.5

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            ZStack {
                if isLandscape {
                    ZStack {
                        Image(.backgroundLoading)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.35)

                        
                        Image(wheelImages[min(currentWheelImageIndex, wheelImages.count - 1)])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 100)
                            .animation(.easeInOut, value: currentWheelImageIndex)
                            .frame(width: geo.size.width / 2, height: geo.size.height / 2)

                        VStack {
                            Spacer()

                            Image(.loadingFrame)
                                .resizable()
                                .scaledToFit()
                            
                                .frame(width: 220, height: 50)

                            Spacer().frame(height: 30)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)

                        RotateDeviceScreen()
                    }
                }
            }
            if isActive {
                if !isNeeded {
                    if let url = urlToLoad {
                        // Если URL валиден, показываем WebView и записываем значение
                        BrowserView(pageURL: url)
                            .onAppear {
                                isNeeded = false
                            }
                            .transition(.opacity) // Плавный переход
                            .edgesIgnoringSafeArea(.all)
                    }
                }  else {
                        // Если URL не валиден, показываем MenuView и записываем значение
                        MenuView()
                            .onAppear {
                                isNeeded = true
                            }
                            .transition(.opacity) // Плавный переход
                            .edgesIgnoringSafeArea(.all)
                            .padding()
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                
            }
        }
        .onAppear() {
            startAnimation()
                    // Запускаем проверку URL перед переходом
                    Task {
                        // Имитация асинхронного запроса к серверу для проверки URL
                        let validURL = await NetworkManager.isURLValid() // Проверяем, валиден ли URL

                        if validURL, let validLink = URL(string: urlForValidation) {
                            // Если URL валиден, передаем его в urlToLoad
                            self.urlToLoad = validLink
                           
                                withAnimation {
                                    isNeeded = true
                                    isActive = true
                                }
                            
                        } else {
                          
                            self.urlToLoad = URL(string: urlForValidation)
                            isNeeded = false
                            isActive = true
                            
                            
                        }
                    }
        }
    }

    private func startAnimation() {
        guard isAnimating else { return }

        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { timer in
            if progress < 100 {
                progress += 10 // Увеличиваем прогресс на 10% за каждый шаг
                currentWheelImageIndex = progress / (100 / wheelImages.count)
            } else {
                currentWheelImageIndex = wheelImages.count - 1 // Оставляем последний кадр
                isAnimating = false
                timer.invalidate() // Останавливаем таймер
            }
        }
    }
}


#Preview {
    LoadingScreen()
}
