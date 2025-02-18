import SwiftUI

struct MainGame: View {
    @State private var nests: [CGPoint] = [] // Массив для хранения позиций гнёзд
    @State private var birds: [Bird] = [] // Массив для хранения птиц
    @State private var warnings: [Warning] = [] // Массив для хранения предупреждений
    @State private var crashes: [Crash] = [] // Массив для хранения столкновений
    @State private var isGameOver = false // Состояние завершения игры
    @State private var isWin = false // Состояние победы
    @State private var score = 0 // Счетчик очков
    @State private var timeRemaining = 60 // Таймер на 1 минуту (60 секунд)
    @State private var isPaused = false
    @State private var maxBirdsBeforeLose = 10 // Например, максимум 10 пти
    @AppStorage("coinscore") var coinscore: Int = 10
    @AppStorage("achive1") var achive1: Int = 0
    @AppStorage("achive2") var achive2: Int = 0
    @AppStorage("achive3") var achive3: Int = 0
    @AppStorage("achive4") var achive4: Int = 0
    @AppStorage("achive5") var achive5: Int = 0
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard: String = "background1"

    let timer = Timer.publish(every: Double.random(in: 2...3), on: .main, in: .common).autoconnect()
    let gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Таймер для отсчета времени

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                var isLandscape = geometry.size.width > geometry.size.height
                if isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                Button(action: pauseGame) {
                                    Image(.pauseBtn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.white)
                                        .padding(10)
                                }
                                Spacer()
                                TimeTemplate(time: timeRemaining)
                                    .padding(.leading, 60)
                                Spacer()
                                BalanceTemplate()
                                    .padding(.trailing, 2)
                            }
                            Spacer()
                        }
                        
                            
                            ForEach(nests, id: \.self) { nest in
                                Image("nest")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .position(nest)
                            }
                            
                            ForEach(warnings) { warning in
                                WarningView(warning: warning)
                            }
                            
                        ForEach(crashes) { crash in
                            if !nests.contains(where: { nest in
                                abs(nest.x - crash.position.x) < 30 && abs(nest.y - crash.position.y) < 30
                            }) {
                                CrashView(crash: crash)
                            }
                        }
                            
                            ForEach(birds) { bird in
                                BirdView(bird: bird)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                updatePath(for: bird, location: value.location)
                                            }
                                            .onEnded { _ in
                                                followPath(for: bird)
                                            }
                                    )
                            }
                        
                        
                        if isGameOver {
                            if isWin {
                                WinView { geometry in
                                    resetGame(geometry: geometry) // Передаем geometry в resetGame
                                }
                            } else {
                                LoseView{ geometry in
                                    resetGame(geometry: geometry) // Передаем geometry в resetGame
                                }
                            }
                        }
                        
                        
                        if isPaused {
                                            PauseView(resumeAction: {
                                                isPaused = false
                                            })
                                        }
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(
                        Image(currentSelectedCloseCard)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .scaleEffect(1.1)
                    )
                    .onAppear {
                        placeNests(geometry: geometry)
                    }
                    .onReceive(timer) { _ in
                        if !isGameOver && !isPaused { // Добавлено условие для проверки паузы
                            spawnBird(geometry: geometry)
                        }
                    }
                    .onReceive(gameTimer) { _ in
                        if !isGameOver && !isPaused { // Добавлено условие для проверки паузы
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            } else {
                                isGameOver = true
                                isWin = true // Победа по истечении времени
                            }
                        }
                    }
                    .onAppear {
                        startBirdMovement(geometry: geometry)
                    }

                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        RotateDeviceScreen()
                    }
                }
            }
        }
        
    }
    
    func resetGame(geometry: GeometryProxy) {
        timeRemaining = 60 // Сброс таймера
        isGameOver = false
        isWin = false
        score = 0
        birds.removeAll()
        warnings.removeAll()
        crashes.removeAll()
        placeNests(geometry: geometry) // Перезапуск игры
        
        // Запускаем движение птиц после перезапуска игры
        startBirdMovement(geometry: geometry)
    }
    
    func pauseGame() {
           isPaused.toggle()
       }
    
    func placeNests(geometry: GeometryProxy) {
        nests = (0..<3).map { _ in
            CGPoint(
                x: CGFloat.random(in: geometry.size.width * 0.2...geometry.size.width * 0.8),
                y: CGFloat.random(in: geometry.size.height * 0.2...geometry.size.height * 0.8)
            )
        }
    }
    
    func spawnBird(geometry: GeometryProxy) {
        let side = Int.random(in: 0...2)
        let startPosition: CGPoint
        let targetPosition: CGPoint
        let warningPosition: CGPoint
        
        switch side {
        case 0: // Левая сторона
            startPosition = CGPoint(x: -30, y: CGFloat.random(in: 0...geometry.size.height))
            targetPosition = CGPoint(x: geometry.size.width / 2, y: CGFloat.random(in: 0...geometry.size.height))
            warningPosition = CGPoint(x: -50, y: startPosition.y) // Позиция предупреждения слева
        case 1: // Правая сторона
            startPosition = CGPoint(x: geometry.size.width + 30, y: CGFloat.random(in: 0...geometry.size.height))
            targetPosition = CGPoint(x: geometry.size.width / 2, y: CGFloat.random(in: 0...geometry.size.height))
            warningPosition = CGPoint(x: geometry.size.width + 50, y: startPosition.y) // Позиция предупреждения справа
        default: // Нижняя сторона
            startPosition = CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height + 30)
            targetPosition = CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: geometry.size.height / 2)
            warningPosition = CGPoint(x: startPosition.x, y: geometry.size.height + 50) // Позиция предупреждения снизу
        }
        
        // Добавляем предупреждение за 2 секунды до спавна птицы
        let warning = Warning(position: warningPosition)
        warnings.append(warning)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            birds.append(Bird(position: startPosition, target: targetPosition))
            if let index = warnings.firstIndex(where: { $0.id == warning.id }) {
                warnings.remove(at: index) // Удаляем предупреждение через 2 секунды
            }
        }
    }
    
    func startBirdMovement(geometry: GeometryProxy) {
        DispatchQueue.global().async {
            while !isGameOver {
                if !isPaused { // Проверяем паузу
                    Thread.sleep(forTimeInterval: 0.04) // Обновляем позицию каждые 50 мс
                    
                    // Собираем индексы птиц для удаления
                    var indicesToRemove: [Int] = []
                    
                    for i in birds.indices {
                        let bird = birds[i]
                        if let updatedBird = updateBirdPosition(bird: bird, geometry: geometry) {
                            birds[i] = updatedBird
                        } else {
                            indicesToRemove.append(i) // Отмечаем птицу для удаления
                        }
                    }
                    
                    // Безопасно удаляем птиц после обработки
                    withAnimation {
                        for index in indicesToRemove.sorted(by: >) {
                            birds.remove(at: index)
                        }
                    }
                    
                    // Проверяем столкновения
                    checkForCollisions()
                }
            }
        }
    }
    
    func updateBirdPosition(bird: Bird, geometry: GeometryProxy) -> Bird? {
        // Проверяем, достигла ли птица гнезда
        if checkIfBirdReachedNest(bird: bird) {
            coinscore += 10 // Увеличиваем счет
            
            return nil // Удаляем птицу
        }
        
        // Если есть путь, следуем ему
        if !bird.path.isEmpty {
            return moveAlongPath(bird: bird)
        }
        
        // Иначе движемся к целевой точке
        let dx = bird.target.x - bird.position.x
        let dy = bird.target.y - bird.position.y
        let distance = sqrt(dx * dx + dy * dy)
        
        if distance < 5 { // Если птица достигла цели, удаляем её
            return nil
        } else {
            let step = 2.0
            let updatedPosition = CGPoint(
                x: bird.position.x + (dx / distance * step),
                y: bird.position.y + (dy / distance * step)
            )
            
            var updatedBird = bird
            updatedBird.position = updatedPosition
            return updatedBird
        }
    }
    
    func moveAlongPath(bird: Bird) -> Bird? {
        guard !bird.path.isEmpty else { return bird }
        
        let nextPoint = bird.path[0]
        let dx = nextPoint.x - bird.position.x
        let dy = nextPoint.y - bird.position.y
        let distance = sqrt(dx * dx + dy * dy)
        
        if distance < 5 { // Если птица достигла точки пути, удаляем её из пути
            var updatedBird = bird
            updatedBird.path.removeFirst()
            return updatedBird
        } else {
            let step = 5.0
            let updatedPosition = CGPoint(
                x: bird.position.x + (dx / distance * step),
                y: bird.position.y + (dy / distance * step)
            )
            
            var updatedBird = bird
            updatedBird.position = updatedPosition
            return updatedBird
        }
    }
    
    func updatePath(for bird: Bird, location: CGPoint) {
        if let index = birds.firstIndex(where: { $0.id == bird.id }) {
            var updatedBird = bird
            updatedBird.path.append(location)
            birds[index] = updatedBird
        }
    }
    
    func followPath(for bird: Bird) {
        // Здесь ничего делать не нужно, так как движение уже обрабатывается в updateBirdPosition
    }
    
    func checkIfBirdReachedNest(bird: Bird) -> Bool {
        for nest in nests {
            let dx = nest.x - bird.position.x
            let dy = nest.y - bird.position.y
            let distance = sqrt(dx * dx + dy * dy)
            if distance < 30 { // Если птица достаточно близко к гнезду
                showCrashAt(position: bird.position) // Показываем "crash" при столкновении
                return true
            }
        }
        return false
    }
    
    func checkForCollisions() {
        for i in 0..<birds.count {
            for j in (i + 1)..<birds.count {
                let bird1 = birds[i]
                let bird2 = birds[j]
                
                let dx = bird1.position.x - bird2.position.x
                let dy = bird1.position.y - bird2.position.y
                let distance = sqrt(dx * dx + dy * dy)
                
                if distance < 30 { // Если птицы достаточно близко друг к другу
                    isGameOver = true // Завершаем игру
                    showCrashAt(position: bird1.position) // Показываем "crash" при столкновении
                    print("Collision detected! Game Over.")
                    return
                }
            }
        }
        achive1 += 1
        achive2 += 1
    }
    
    func showCrashAt(position: CGPoint) {
        let crash = Crash(position: position)
        crashes.append(crash)
        
        // Удаляем "crash" через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let index = crashes.firstIndex(where: { $0.id == crash.id }) {
                crashes.remove(at: index)
            }
        }
    }
}

struct BirdView: View {
    @State private var currentFrame = 1 // Текущий фрейм анимации
    let bird: Bird

    var body: some View {
        ZStack {
            Image("frame\(currentFrame)") // Отображаем текущий фрейм
                .resizable()
                .frame(width: 50, height: 50)
                .position(bird.position)
                .onAppear {
                    startAnimation() // Запускаем анимацию при появлении
                }
                .overlay(
                    Path { path in
                        if let firstPoint = bird.path.first {
                            path.move(to: firstPoint)
                            for point in bird.path {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                )
                .animation(.linear(duration: 0.001), value: currentFrame)
        }
    }

    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            withAnimation(.linear(duration: 0.1)) {
                currentFrame += 1 // Переходим к следующему фрейму
                if currentFrame > 9 { // Если достигли последнего фрейма, возвращаемся к первому
                    currentFrame = 1
                }
            }
        }
    }
}

struct WarningView: View {
    let warning: Warning
    
    var body: some View {
        Image("warning")
            .resizable()
            .frame(width: 50, height: 50)
            .position(warning.position)
    }
}

struct CrashView: View {
    let crash: Crash
    
    var body: some View {
        Image("crash")
            .resizable()
            .frame(width: 50, height: 50)
            .position(crash.position)
    }
}

struct Bird: Identifiable {
    let id = UUID()
    var position: CGPoint
    var target: CGPoint
    var path: [CGPoint] = [] // Для хранения траектории
}

struct Warning: Identifiable {
    let id = UUID()
    var position: CGPoint
}

struct Crash: Identifiable {
    let id = UUID()
    var position: CGPoint
}

struct TimeTemplate: View {
    var time: Int
    var body: some View {
        ZStack {
            Image(.timer)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(time)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 75, y: 35)
                    }
                )
        }
    }
}

struct PauseView: View {
    var resumeAction: () -> Void

    var body: some View {
        ZStack {
            Image(.pausePlate)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .frame(width: 380, height: 380)
 
            VStack(spacing: -40) {
                Button(action: resumeAction) {
                    Image(.resumeBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 90)
                }
                
                Image(.menuBtn)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 90)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
            .padding(.top, -5)
        }
    }
}

struct WinView: View {
    var retryAction: (GeometryProxy) -> Void // Добавляем GeometryProxy в параметр
    @AppStorage("level") var level: Int = 1 // Переменная для хранения текущего уровня
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.winPlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 380)
                    .padding(.top, 60)
                
                VStack(spacing: -40) {
                    Image(.winText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 80)
                    
                    
                    Button(action: {
                        retryAction(geometry) // Передаем geometry в retryAction
                        level += 1
                    }) {
                        Image(.nextLevelBtn)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 90)
                    }
                    
                    Image(.menuBtn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 90)
                        .onTapGesture {
                            NavGuard.shared.currentScreen = .MENU
                            level += 1
                        }
                }
                .padding(.top, 90)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct LoseView: View {
    var retryAction: (GeometryProxy) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.losePlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 380, height: 380)
                    .padding(.top, 60)
                
                VStack(spacing: -40) {
                    
                    Image(.loseText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 80)
                    
                    Button(action: {
                        retryAction(geometry) // Передаем geometry в retryAction
                    }) {
                        Image(.retryBtn)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 90)
                    }
                    
                        Image(.menuBtn)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 90)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                }
                .padding(.top, 50)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    MainGame()
}
