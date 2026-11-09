import SwiftUI

public struct DuplaBadge: View {
    public enum Variant {
        case dot
        case stamp
    }

    public enum Tone {
        case accent
        case neutral
    }

    private let title: LocalizedStringKey
    private let variant: Variant
    private let tone: Tone

    public init(_ title: LocalizedStringKey, variant: Variant = .dot, tone: Tone = .accent) {
        self.title = title
        self.variant = variant
        self.tone = tone
    }

    public var body: some View {
        let color = tone == .accent ? DuplaColors.ink : DuplaColors.mutedText

        HStack(spacing: 6) {
            if variant == .dot {
                Circle()
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)
            }
            Text(title)
                .duplaTextStyle(.caption)
        }
        .foregroundStyle(color)
        .padding(.horizontal, variant == .stamp ? DuplaMetrics.small : 0)
        .padding(.vertical, variant == .stamp ? 4 : 0)
        .overlay {
            if variant == .stamp {
                SketchStroke(.stamp, color: color, lineWidth: 1)
            }
        }
    }
}

#if DEBUG
#Preview("Pastilles Dupla") {
    Grid(horizontalSpacing: DuplaMetrics.large, verticalSpacing: DuplaMetrics.medium) {
        GridRow {
            DuplaBadge("À explorer")
            DuplaBadge("Archivées", tone: .neutral)
        }
        GridRow {
            DuplaBadge("À explorer", variant: .stamp)
            DuplaBadge("Archivées", variant: .stamp, tone: .neutral)
        }
    }
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
