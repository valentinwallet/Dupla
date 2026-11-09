import SwiftUI

public struct DuplaTextField: View {
    public enum Kind {
        case standard
        case search
        case notes
    }

    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @ScaledMetric(relativeTo: .body) private var notesHeight: CGFloat = 112
    @Environment(\.isEnabled) private var isEnabled
    private let title: LocalizedStringKey
    private let prompt: LocalizedStringKey?
    private let kind: Kind
    private let error: LocalizedStringKey?

    public init(
        _ title: LocalizedStringKey,
        text: Binding<String>,
        kind: Kind = .standard,
        prompt: LocalizedStringKey? = nil,
        error: LocalizedStringKey? = nil
    ) {
        self.title = title
        self._text = text
        self.kind = kind
        self.prompt = prompt
        self.error = error
    }

    public var body: some View {
        let shape = RoundedRectangle(cornerRadius: DuplaMetrics.controlRadius)

        VStack(alignment: .leading, spacing: DuplaMetrics.extraSmall) {
            Text(title)
                .duplaTextStyle(.caption, weight: .semibold)
                .accessibilityHidden(true)

            Group {
                if kind == .notes {
                    notesEditor
                } else {
                    singleLineField
                }
            }
            .padding(.horizontal, DuplaMetrics.medium)
            .padding(.vertical, DuplaMetrics.small)
            .frame(minHeight: DuplaMetrics.controlHeight)
            .background(isFocused ? DuplaColors.lavender : DuplaColors.paper, in: shape)
            .overlay {
                shape.strokeBorder(borderColor, lineWidth: isFocused ? 2 : 1)
                    .allowsHitTesting(false)
            }

            if let error {
                Label(error, systemImage: "exclamationmark.circle")
                    .duplaTextStyle(.caption)
                    .foregroundStyle(DuplaColors.error)
            }
        }
        .foregroundStyle(DuplaColors.text)
        .opacity(isEnabled ? 1 : 0.55)
    }

    private var singleLineField: some View {
        HStack(spacing: DuplaMetrics.small) {
            if kind == .search {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(DuplaColors.mutedText)
                    .accessibilityHidden(true)
            }

            TextField(
                title,
                text: $text,
                prompt: prompt.map { Text($0).foregroundStyle(DuplaColors.mutedText) }
                    ?? Text(verbatim: "")
            )
            .textFieldStyle(.plain)
            .duplaTextStyle(.body)
            .lineLimit(1)
            .focused($isFocused)
            .tint(DuplaColors.ink)
        }
    }

    private var notesEditor: some View {
        TextEditor(text: $text)
            .textEditorStyle(.plain)
            .scrollContentBackground(.hidden)
            .duplaTextStyle(.body)
            .focused($isFocused)
            .tint(DuplaColors.ink)
            .accessibilityLabel(Text(title))
            .accessibilityHint(prompt.map { Text($0) } ?? Text(verbatim: ""))
            .frame(height: notesHeight)
            .overlay(alignment: .topLeading) {
                if text.isEmpty, let prompt {
                    Text(prompt)
                        .duplaTextStyle(.body)
                        .foregroundStyle(DuplaColors.mutedText)
                        // Match the native text container's first line.
                        .padding(.horizontal, 5)
                        #if os(iOS)
                        .padding(.top, 8)
                        #endif
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
    }

    private var borderColor: Color {
        if error != nil { return DuplaColors.error }
        return isFocused ? DuplaColors.ink : DuplaColors.border
    }
}

#if DEBUG
#Preview("Champs Dupla") {
    DuplaTextFieldPreview()
}

#Preview("Champ Notes Dupla") {
    DuplaNotesPreview()
}

private struct DuplaTextFieldPreview: View {
    @State private var version = "Version 02"
    @State private var query = ""

    var body: some View {
        VStack(spacing: DuplaMetrics.large) {
            DuplaTextField("Nom de la version", text: $version)
            DuplaTextField("Rechercher", text: $query, kind: .search, prompt: "Rechercher une photo")
            DuplaTextField(
                "Nom du projet",
                text: .constant(""),
                error: "Saisis un nom pour continuer."
            )
        }
        .frame(width: 300)
        .padding(DuplaMetrics.section)
        .background(DuplaColors.paper)
    }
}

private struct DuplaNotesPreview: View {
    @State private var emptyNote = ""
    @State private var draft = "Reprendre les photos au lever du jour.\nEssayer un cadrage plus serré."

    var body: some View {
        VStack(spacing: DuplaMetrics.large) {
            DuplaTextField("Notes", text: $emptyNote, kind: .notes, prompt: "Une idée pour la suite…")
            DuplaTextField("Brouillon", text: $draft, kind: .notes)
        }
        .frame(width: 300)
        .padding(DuplaMetrics.section)
        .background(DuplaColors.paper)
    }
}
#endif
