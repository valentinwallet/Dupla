import CoreText
import Foundation
import SwiftUI

public enum DuplaTextStyle {
    public enum Weight: CaseIterable, Hashable {
        case regular
        case semibold
        case bold

        fileprivate func applying(to font: Font) -> Font {
            switch self {
            case .regular: font
            case .semibold: font.weight(.semibold)
            case .bold: font.weight(.bold)
            }
        }
    }

    case display
    case title
    case note
    case body
    case label
    case caption

    public var font: Font { font(weight: .regular) }

    /// The handwritten roles use Annie in Regular at every weight.
    public func font(weight: Weight) -> Font {
        switch self {
        case .display: DuplaFont.annie.font(size: 44, relativeTo: .largeTitle)
        case .title: DuplaFont.annie.font(size: 30, relativeTo: .title2)
        case .note: DuplaFont.annie.font(size: 23, relativeTo: .body)
        case .body: weight.applying(to: .body)
        case .label: DuplaFont.mono(weight).font(size: 14, relativeTo: .callout)
        case .caption: DuplaFont.mono(weight).font(size: 12, relativeTo: .caption)
        }
    }
}

public extension View {
    func duplaTextStyle(
        _ style: DuplaTextStyle,
        weight: DuplaTextStyle.Weight = .regular
    ) -> some View {
        font(style.font(weight: weight))
    }
}

private enum DuplaFont: Hashable {
    case annie
    case mono(DuplaTextStyle.Weight)

    private static let faces: [Self] = [.annie] + DuplaTextStyle.Weight.allCases.map(Self.mono)

    private var resource: String {
        switch self {
        case .annie: "AnnieUseYourTelescope"
        case .mono(.regular): "IBMPlexMono"
        case .mono(.semibold): "IBMPlexMono-SemiBold"
        case .mono(.bold): "IBMPlexMono-Bold"
        }
    }

    private static let postScriptNames: [Self: String] = Dictionary(
        uniqueKeysWithValues: faces.compactMap { face in
            guard let url = Bundle.module.url(
                forResource: face.resource, withExtension: "ttf", subdirectory: "Fonts"
            ),
                let descriptor = (CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor])?.first,
                let name = CTFontDescriptorCopyAttribute(descriptor, kCTFontNameAttribute) as? String
            else { return nil }

            if CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) {
                return (face, name)
            }

            // A host app can already have registered this face.
            let registeredFont = CTFontCreateWithName(name as CFString, 12, nil)
            return CTFontCopyPostScriptName(registeredFont) as String == name ? (face, name) : nil
        }
    )

    func font(size: CGFloat, relativeTo style: Font.TextStyle) -> Font {
        guard let name = Self.postScriptNames[self] else {
            switch self {
            case .annie: return .system(style)
            case .mono(let weight): return weight.applying(to: .system(style, design: .monospaced))
            }
        }
        return .custom(name, size: size, relativeTo: style)
    }
}

#if DEBUG
#Preview("Typographies Dupla") {
    VStack(alignment: .leading, spacing: DuplaMetrics.small) {
        Text("Bibliothèque")
            .duplaTextStyle(.display)
        Text("Aucune photo à afficher")
            .duplaTextStyle(.title)
        Text("À publier")
            .duplaTextStyle(.note)
        Text("Ajoute des photos pour composer la suite.")
            .duplaTextStyle(.body)
        Text("Rechercher une photo")
            .duplaTextStyle(.label)
        Text("12 photos")
            .duplaTextStyle(.caption)
    }
    .foregroundStyle(DuplaColors.text)
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}

#Preview("Graisses IBM Plex Mono") {
    let samples: [(DuplaTextStyle.Weight, String)] = [
        (.regular, "Regular"), (.semibold, "SemiBold"), (.bold, "Bold"),
    ]

    Grid(alignment: .leading, horizontalSpacing: DuplaMetrics.medium, verticalSpacing: DuplaMetrics.medium) {
        ForEach(samples, id: \.0) { weight, name in
            GridRow {
                Text(name)
                    .duplaTextStyle(.label, weight: weight)
                Text("Rechercher une photo")
                    .duplaTextStyle(.label, weight: weight)
                Text("12 photos")
                    .duplaTextStyle(.caption, weight: weight)
            }
        }
    }
    .foregroundStyle(DuplaColors.text)
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
