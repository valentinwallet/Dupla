import SwiftUI

public struct DuplaTape<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            .overlay(alignment: .top) {
                MaterialSlice(.kraftTape)
                    .opacity(0.88)
                    .frame(width: 74, height: 20)
                    .shadow(color: .black.opacity(0.18), radius: 1.5, x: 0, y: 1)
                    .rotationEffect(.degrees(-7))
                    .offset(x: -6, y: -5)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
    }
}

#if DEBUG
#Preview("Scotch kraft Dupla") {
    VStack(spacing: DuplaMetrics.section) {
        DuplaTape {
            Image(systemName: "photo")
                .font(.largeTitle)
                .frame(width: 155, height: 112)
                .foregroundStyle(DuplaColors.ink)
                .background(DuplaColors.lavender)
        }

        DuplaTape {
            Text("Revoir cette lumière")
                .duplaTextStyle(.note)
                .foregroundStyle(DuplaColors.ink)
                .padding(DuplaMetrics.section)
                .background(DuplaColors.paper)
        }
    }
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
