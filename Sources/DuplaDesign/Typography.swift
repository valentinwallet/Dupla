import CoreText
import Foundation
import SwiftUI

public enum DuplaTextStyle {
    case display
    case title
    case note
    case body
    case label
    case caption

    public var font: Font {
        switch self {
        case .display: DuplaFont.annie.font(size: 44, relativeTo: .largeTitle)
        case .title: DuplaFont.annie.font(size: 30, relativeTo: .title2)
        case .note: DuplaFont.annie.font(size: 23, relativeTo: .body)
        case .body: .body
        case .label: DuplaFont.mono.font(size: 14, relativeTo: .callout)
        case .caption: DuplaFont.mono.font(size: 12, relativeTo: .caption)
        }
    }
}

public extension View {
    func duplaTextStyle(_ style: DuplaTextStyle) -> some View {
        font(style.font)
    }
}

private enum DuplaFont: CaseIterable {
    case annie
    case mono

    private var resource: String {
        switch self {
        case .annie: "AnnieUseYourTelescope"
        case .mono: "IBMPlexMono"
        }
    }

    private static let postScriptNames: [Self: String] = Dictionary(
        uniqueKeysWithValues: allCases.compactMap { face in
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
            return .system(style, design: self == .mono ? .monospaced : .default)
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
#endif
