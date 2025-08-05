import SwiftUI

// MARK: - Протоколы (оставлены как есть)
protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Лоадинг: неоновый стиль
struct EggscellentLoadingOverlay<Background: View>: View, ProgressDisplayable {
    let progress: Double
    let backgroundView: Background
    
    var progressPercentage: Int { Int(progress * 100) }
    
    init(progress: Double, @ViewBuilder background: () -> Background) {
        self.progress = progress
        self.backgroundView = background()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                content(in: geo)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func content(in geometry: GeometryProxy) -> some View {
        let isLandscape = geometry.size.width > geometry.size.height
        
        return Group {
            if isLandscape {
                horizontalLayout(in: geometry)
            } else {
                verticalLayout(in: geometry)
            }
        }
    }
    
    private func verticalLayout(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Неоновый логотип
            ZStack {
                Text("EGG")
                    .font(.system(size: 50, weight: .black))
                    .foregroundColor(.clear)
                    .blur(radius: 12)
                
                Text("EGG")
                    .font(.system(size: 50, weight: .black))
                    .foregroundColor(Color(hex: "FF00AA"))
                    .shadow(color: Color(hex: "FF00AA").opacity(0.7), radius: 10, x: 0, y: 0)
                    .blur(radius: 2)
                
                Text("EGG")
                    .font(.system(size: 50, weight: .black))
                    .foregroundColor(.white)
                    .offset(x: sin(progress * .pi * 4) * 3) // лёгкое дрожание
            }
            .scaleEffect(1 + progress / 10) // растёт с прогрессом
            .animation(.easeInOut(duration: 0.3), value: progress)
            
            progressSection(width: geometry.size.width * 0.7)
            
            Text("CELL\nENT")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .kerning(2)
                .lineSpacing(4)
                .shadow(radius: 6)
            
            Spacer()
        }
        .padding()
    }
    
    private func horizontalLayout(in geometry: GeometryProxy) -> some View {
        HStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Text("EGG")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.clear)
                        .blur(radius: 8)
                    
                    Text("EGG")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(Color(hex: "FF00AA"))
                        .shadow(color: Color(hex: "FF00AA").opacity(0.7), radius: 8)
                    
                    Text("EGG")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                }
                .scaleEffect(1 + progress / 15)
                .animation(.easeInOut(duration: 0.3), value: progress)
                
                progressSection(width: geometry.size.width * 0.3)
            }
            
            VStack(spacing: 16) {
                Text("EGGCELL\nENT")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .frame(width: geometry.size.width * 0.35)
            
            Spacer()
        }
        .padding()
    }
    
    private func progressSection(width: CGFloat) -> some View {
        VStack(spacing: 12) {
            Text("Loading \(progressPercentage)%")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .shadow(radius: 1)
            
            EggscellentProgressBar(value: progress)
                .frame(width: width, height: 10)
        }
        .padding(16)
        .background(Color.black.opacity(0.25))
        .cornerRadius(16)
        .padding(.bottom, 20)
    }
}

// MARK: - Фон: градиент в стиле "неон-ночь"
extension EggscellentLoadingOverlay where Background == EggscellentBackground {
    init(progress: Double) {
        self.init(progress: progress) { EggscellentBackground() }
    }
}

struct EggscellentBackground: View, BackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "12002B"), // тёмно-фиолетовый
                Color(hex: "2B004F"), // глубокий
                Color(hex: "4A0082"), // ярче к центру
                Color(hex: "2B004F")
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    var body: some View {
        makeBackground()
    }
}

// MARK: - Прогресс-бар: градиентный с неоновым эффектом
struct EggscellentProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Фон
                Capsule()
                    .fill(Color.white.opacity(0.15))
                
                // Прогресс
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "FF00AA"), // розовый
                                Color(hex: "7B00FF"), // фиолетовый
                                Color(hex: "00E0FF")  // бирюзовый
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(value) * geometry.size.width, height: 10)
                    .animation(.easeInOut(duration: 0.3), value: value)
                
                // Эффект свечения
                if value > 0 {
                    Capsule()
                        .stroke(Color(hex: "FF00AA").opacity(0.5), lineWidth: 2)
                        .blur(radius: 2)
                        .frame(width: CGFloat(value) * geometry.size.width, height: 14)
                }
            }
        }
        .cornerRadius(5)
    }
}

// MARK: - Превью
#Preview("Vertical") {
    EggscellentLoadingOverlay(progress: 0.4)
}

#Preview("Horizontal") {
    EggscellentLoadingOverlay(progress: 0.4)
        .previewInterfaceOrientation(.landscapeRight)
}
