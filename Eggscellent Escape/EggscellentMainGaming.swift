import SwiftUI
import Foundation

struct EggscellentEntryScreen: View {
    @StateObject private var loader: EggscellentWebLoader

    init(loader: EggscellentWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            EggscellentWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                EggscellentProgressIndicator(value: percent)
            case .failure(let err):
                EggscellentErrorIndicator(err: err) // err теперь String
            case .noConnection:
                EggscellentOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct EggscellentProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            EggscellentLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct EggscellentErrorIndicator: View {
    let err: String // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct EggscellentOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
