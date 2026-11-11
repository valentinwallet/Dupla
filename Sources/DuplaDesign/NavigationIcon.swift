import SwiftUI

/// Small, fixed hand-drawn paths keep the navigation organic without jitter.
public struct DuplaNavigationIcon: View {
    public enum Symbol: CaseIterable, Sendable {
        case versions, library, inspirations, notebook, trash, settings
    }

    private let symbol: Symbol

    public init(_ symbol: Symbol) { self.symbol = symbol }

    public var body: some View {
        IconShape(symbol: symbol)
            .stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            .frame(width: 24, height: 24)
            .accessibilityHidden(true)
    }
}

private struct IconShape: Shape {
    let symbol: DuplaNavigationIcon.Symbol

    func path(in rect: CGRect) -> Path {
        var p = Path()
        switch symbol {
        case .versions:
            p.move(to: CGPoint(x: 7, y: 4))
            p.addLines([CGPoint(x: 20, y: 3.5), CGPoint(x: 20.5, y: 17), CGPoint(x: 18, y: 17)])
            p.move(to: CGPoint(x: 4, y: 7))
            p.addLines([CGPoint(x: 16.5, y: 6.5), CGPoint(x: 17, y: 20), CGPoint(x: 3.5, y: 20.5), CGPoint(x: 4, y: 7)])
        case .library:
            p.move(to: CGPoint(x: 3.5, y: 6))
            p.addLines([CGPoint(x: 19, y: 5.5), CGPoint(x: 20, y: 20), CGPoint(x: 4, y: 19.5), CGPoint(x: 3.5, y: 6)])
            p.move(to: CGPoint(x: 7, y: 3))
            p.addLine(to: CGPoint(x: 21.5, y: 3.5))
            p.move(to: CGPoint(x: 5, y: 16.5))
            p.addLines([CGPoint(x: 10, y: 11.5), CGPoint(x: 13, y: 14), CGPoint(x: 16, y: 12), CGPoint(x: 19, y: 16)])
            p.addEllipse(in: CGRect(x: 14, y: 8, width: 2.5, height: 2.5))
        case .inspirations:
            p.move(to: CGPoint(x: 12, y: 3))
            p.addQuadCurve(to: CGPoint(x: 20, y: 12), control: CGPoint(x: 13, y: 11))
            p.addQuadCurve(to: CGPoint(x: 11.5, y: 21), control: CGPoint(x: 12.5, y: 13))
            p.addQuadCurve(to: CGPoint(x: 3, y: 12.5), control: CGPoint(x: 11, y: 13))
            p.addQuadCurve(to: CGPoint(x: 12, y: 3), control: CGPoint(x: 11, y: 11.5))
            p.move(to: CGPoint(x: 19, y: 3))
            p.addLine(to: CGPoint(x: 19, y: 7))
            p.move(to: CGPoint(x: 17, y: 5))
            p.addLine(to: CGPoint(x: 21, y: 5))
        case .notebook:
            p.move(to: CGPoint(x: 6, y: 3.5))
            p.addLines([CGPoint(x: 19, y: 4), CGPoint(x: 18.5, y: 20), CGPoint(x: 5, y: 20.5), CGPoint(x: 6, y: 3.5)])
            for y in [7.0, 12, 17] {
                p.move(to: CGPoint(x: 3, y: y))
                p.addLine(to: CGPoint(x: 7, y: y - 0.3))
            }
            p.move(to: CGPoint(x: 10, y: 8))
            p.addLine(to: CGPoint(x: 15.5, y: 8.5))
            p.move(to: CGPoint(x: 10, y: 12))
            p.addLine(to: CGPoint(x: 14, y: 11.7))
        case .trash:
            p.move(to: CGPoint(x: 4, y: 7))
            p.addLine(to: CGPoint(x: 20, y: 6.5))
            p.move(to: CGPoint(x: 6, y: 9))
            p.addLines([CGPoint(x: 7, y: 20), CGPoint(x: 17, y: 20.5), CGPoint(x: 18.5, y: 9)])
            p.move(to: CGPoint(x: 9, y: 5))
            p.addQuadCurve(to: CGPoint(x: 15, y: 5), control: CGPoint(x: 11.5, y: 0))
            p.move(to: CGPoint(x: 10, y: 11))
            p.addLine(to: CGPoint(x: 10.5, y: 17))
            p.move(to: CGPoint(x: 14.5, y: 11))
            p.addLine(to: CGPoint(x: 14, y: 17))
        case .settings:
            for (x, y) in [(6.0, 8.0), (12, 16), (18, 10)] {
                p.move(to: CGPoint(x: x, y: 3.5))
                p.addLine(to: CGPoint(x: x + 0.3, y: y - 2))
                p.move(to: CGPoint(x: x + 0.3, y: y + 2))
                p.addLine(to: CGPoint(x: x - 0.2, y: 21))
                p.addRoundedRect(in: CGRect(x: x - 2.5, y: y - 2, width: 5, height: 4), cornerSize: CGSize(width: 1, height: 1))
            }
        }
        return p.applying(CGAffineTransform(a: rect.width / 24, b: 0, c: 0, d: rect.height / 24, tx: rect.minX, ty: rect.minY))
    }
}

#if DEBUG
#Preview("Navigation Dupla") {
    HStack(spacing: DuplaMetrics.large) {
        ForEach(Array(DuplaNavigationIcon.Symbol.allCases.enumerated()), id: \.offset) { _, symbol in
            DuplaNavigationIcon(symbol)
        }
    }
    .foregroundStyle(DuplaColors.ink)
    .padding(DuplaMetrics.section)
    .background(DuplaColors.panel)
}
#endif
