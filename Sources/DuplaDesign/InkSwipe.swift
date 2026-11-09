import SwiftUI

public struct DuplaInkSwipe: View {
    public init() {}

    public var body: some View {
        DuplaColors.ink
            .mask {
                MaterialSlice(.inkBrush)
                    .luminanceToAlpha()
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

#if DEBUG
#Preview("Encre Dupla") {
    Label("Bibliothèque", systemImage: "photo.on.rectangle.angled")
        .duplaTextStyle(.label)
        .foregroundStyle(DuplaColors.onInk)
        .padding(.horizontal, DuplaMetrics.medium)
        .frame(width: 220, height: DuplaMetrics.controlHeight, alignment: .leading)
        .background { DuplaInkSwipe() }
        .padding(DuplaMetrics.section)
        .background(DuplaColors.paper)
}
#endif
