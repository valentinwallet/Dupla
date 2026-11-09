import SwiftUI

public enum DuplaColors {
    public static let paper = Color("Paper", bundle: .module)
    public static let ink = Color("Ink", bundle: .module)
    public static let onInk = Color("OnInk", bundle: .module)
    public static let text = Color("Text", bundle: .module)
    public static let mutedText = Color("MutedText", bundle: .module)
    public static let border = Color("Border", bundle: .module)
    public static let lavender = Color("Lavender", bundle: .module)
    public static let error = Color("Error", bundle: .module)
}

public enum DuplaMetrics {
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let section: CGFloat = 24
    public static let controlRadius: CGFloat = 7
    public static let controlHeight: CGFloat = 48
}

#if DEBUG
#Preview("Palette Dupla") {
    let colors: [(String, Color)] = [
        ("paper", DuplaColors.paper), ("ink", DuplaColors.ink),
        ("onInk", DuplaColors.onInk), ("text", DuplaColors.text),
        ("mutedText", DuplaColors.mutedText), ("border", DuplaColors.border),
        ("lavender", DuplaColors.lavender), ("error", DuplaColors.error),
    ]

    VStack(alignment: .leading, spacing: DuplaMetrics.small) {
        ForEach(colors.indices, id: \.self) { index in
            HStack(spacing: DuplaMetrics.medium) {
                RoundedRectangle(cornerRadius: DuplaMetrics.controlRadius)
                    .fill(colors[index].1)
                    .overlay {
                        RoundedRectangle(cornerRadius: DuplaMetrics.controlRadius)
                            .strokeBorder(DuplaColors.border)
                    }
                    .frame(width: 48, height: 26)
                Text(colors[index].0)
                    .duplaTextStyle(.label)
            }
        }
    }
    .foregroundStyle(DuplaColors.text)
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
