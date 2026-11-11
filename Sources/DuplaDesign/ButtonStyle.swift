import SwiftUI

public struct DuplaButtonStyle: ButtonStyle {
    public enum Variant {
        case primary
        case outline
        case lavender
        case pencil
    }

    public enum Size {
        /// The original, generous button size, used when no size is specified.
        case regular
        case small
    }

    @Environment(\.isEnabled) private var isEnabled
    private let variant: Variant
    private let size: Size

    public init(_ variant: Variant = .primary, size: Size = .regular) {
        self.variant = variant
        self.size = size
    }

    public func makeBody(configuration: Configuration) -> some View {
        let shape = variant == .lavender
            ? AnyShape(Capsule())
            : AnyShape(RoundedRectangle(cornerRadius: DuplaMetrics.controlRadius))

        configuration.label
            .duplaTextStyle(size == .small ? .caption : .label)
            .foregroundStyle(variant == .primary ? DuplaColors.onInk : DuplaColors.ink)
            .overlay(alignment: .bottom) {
                if variant == .pencil {
                    SketchStroke(.singleUnderline)
                        .frame(height: size == .small ? 3 : 4)
                        .offset(y: size == .small ? 3 : 5)
                }
            }
            .padding(.horizontal, self.horizontalPadding)
            .padding(.vertical, size == .small ? DuplaMetrics.extraSmall : DuplaMetrics.small)
            .frame(minHeight: size == .small ? DuplaMetrics.smallControlHeight : DuplaMetrics.controlHeight)
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
    
    private var horizontalPadding: CGFloat {
        switch variant {
            case .pencil:
                0
            default:
                size == .small ? DuplaMetrics.medium : DuplaMetrics.large
        }
    }
}

public extension ButtonStyle where Self == DuplaButtonStyle {
    static func dupla(
        _ variant: DuplaButtonStyle.Variant = .primary,
        size: DuplaButtonStyle.Size = .regular
    ) -> Self {
        Self(variant, size: size)
    }
}

#if DEBUG
#Preview("Boutons Dupla") {
    let variants: [(String, DuplaButtonStyle.Variant)] = [
        ("Continuer", .primary), ("Comparer", .outline),
        ("À explorer", .lavender), ("Modifier la note", .pencil),
    ]
    Grid(alignment: .leading, horizontalSpacing: DuplaMetrics.section, verticalSpacing: DuplaMetrics.large) {
        GridRow {
            Text("Regular · 48 pt").duplaTextStyle(.label)
            Text("Small · 32 pt").duplaTextStyle(.label)
        }
        ForEach(variants.indices, id: \.self) { index in
            GridRow {
                VStack(alignment: .leading, spacing: DuplaMetrics.small) {
                    Button(variants[index].0) {}.buttonStyle(.dupla(variants[index].1))
                    Button(variants[index].0) {}.buttonStyle(.dupla(variants[index].1)).disabled(true)
                }
                VStack(alignment: .leading, spacing: DuplaMetrics.small) {
                    Button(variants[index].0) {}.buttonStyle(.dupla(variants[index].1, size: .small))
                    Button(variants[index].0) {}.buttonStyle(.dupla(variants[index].1, size: .small)).disabled(true)
                }
            }
        }
    }
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
