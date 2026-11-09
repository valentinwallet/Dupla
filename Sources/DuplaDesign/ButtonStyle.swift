import SwiftUI

public struct DuplaButtonStyle: ButtonStyle {
    public enum Variant {
        case primary
        case outline
        case lavender
        case pencil
    }

    @Environment(\.isEnabled) private var isEnabled
    private let variant: Variant

    public init(_ variant: Variant = .primary) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        let shape = variant == .lavender
            ? AnyShape(Capsule())
            : AnyShape(RoundedRectangle(cornerRadius: DuplaMetrics.controlRadius))

        configuration.label
            .duplaTextStyle(.label)
            .foregroundStyle(variant == .primary ? DuplaColors.onInk : DuplaColors.ink)
            .overlay(alignment: .bottom) {
                if variant == .pencil {
                    SketchStroke(.singleUnderline)
                        .frame(height: 4)
                        .offset(y: 5)
                }
            }
            .padding(.horizontal, DuplaMetrics.large)
            .padding(.vertical, DuplaMetrics.small)
            .frame(minHeight: DuplaMetrics.controlHeight)
            .background(fill, in: shape)
            .overlay {
                if variant == .outline {
                    shape.stroke(DuplaColors.ink, lineWidth: 1)
                        .allowsHitTesting(false)
                }
            }
            .contentShape(Rectangle())
            .opacity(isEnabled ? (configuration.isPressed ? 0.75 : 1) : 0.45)
    }

    private var fill: Color {
        switch variant {
        case .primary: DuplaColors.ink
        case .lavender: DuplaColors.lavender
        case .outline, .pencil: .clear
        }
    }
}

public extension ButtonStyle where Self == DuplaButtonStyle {
    static func dupla(_ variant: DuplaButtonStyle.Variant = .primary) -> Self {
        Self(variant)
    }
}

#if DEBUG
#Preview("Boutons Dupla") {
    VStack(spacing: DuplaMetrics.medium) {
        Button("Importer une photo…") {}
            .buttonStyle(.dupla())
        Button("Voir la version") {}
            .buttonStyle(.dupla(.outline))
        Button("À explorer") {}
            .buttonStyle(.dupla(.lavender))
        Button("Modifier la note") {}
            .buttonStyle(.dupla(.pencil))
        Button("Enregistrer") {}
            .buttonStyle(.dupla())
            .disabled(true)
    }
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
