import SwiftUI

public struct DuplaEmptyState<Action: View>: View {
    private let title: LocalizedStringKey
    private let message: LocalizedStringKey?
    private let motif: DuplaDoodle.Motif
    private let action: Action

    public init(
        _ title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        motif: DuplaDoodle.Motif = .sun,
        @ViewBuilder action: () -> Action
    ) {
        self.title = title
        self.message = message
        self.motif = motif
        self.action = action()
    }

    public var body: some View {
        VStack(spacing: DuplaMetrics.large) {
            DuplaDoodle(motif)
                .frame(width: 116, height: 76)

            VStack(spacing: 0) {
                Text(title)
                    .duplaTextStyle(.title)
                    .foregroundStyle(DuplaColors.text)
                    .accessibilityAddTraits(.isHeader)

                if let message {
                    Text(message)
                        .duplaTextStyle(.body)
                        .foregroundStyle(DuplaColors.mutedText)
                }
            }

            self.action
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 360)
        .padding(DuplaMetrics.section)
    }
}

public extension DuplaEmptyState where Action == EmptyView {
    init(
        _ title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        motif: DuplaDoodle.Motif = .sun
    ) {
        self.init(title, message: message, motif: motif) { EmptyView() }
    }
}

#if DEBUG
#Preview("État vide Dupla") {
    DuplaEmptyState(
        "Aucune photo à afficher",
        message: "Ajoute des photos pour composer la suite.",
        motif: .flower
    ) {
        Button("Importer une photo…") {}
            .buttonStyle(.dupla(.outline))
    }
    .frame(width: 360)
    .background(DuplaColors.paper)
}
#endif
