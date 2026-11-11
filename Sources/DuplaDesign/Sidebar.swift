//
//  Sidebar.swift
//  DuplaDesign
//
//  Created by Valentin Wallet on 11/11/2026.
//

import SwiftUI

/// A section and its accessory actions share the same selection surface.
public struct DuplaSidebarSection<Actions: View>: View {
    private let title: String
    private let icon: DuplaNavigationIcon.Symbol
    private let isSelected: Bool
    private let expansion: Binding<Bool>?
    private let action: () -> Void
    private let actions: Actions

    public init(_ title: String, icon: DuplaNavigationIcon.Symbol, isSelected: Bool,
                expansion: Binding<Bool>? = nil, action: @escaping () -> Void,
                @ViewBuilder actions: () -> Actions) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.expansion = expansion
        self.action = action
        self.actions = actions()
    }

    public var body: some View {
        HStack(spacing: 0) {
            Button(action: action) {
                Label { Text(title) } icon: { DuplaNavigationIcon(icon) }
                    .duplaTextStyle(.label)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DuplaMetrics.medium)
                    .frame(minHeight: DuplaMetrics.controlHeight)
                    .contentShape(Rectangle())
            }
            .accessibilityAddTraits(isSelected ? [.isSelected] : [])

            actions
                .duplaTextStyle(.label)

            if let expansion {
                Button {
                    expansion.wrappedValue.toggle()
                } label: {
                    Image(systemName: expansion.wrappedValue ? "chevron.down" : "chevron.right")
                        .duplaTextStyle(.caption, weight: .semibold)
                        .frame(width: DuplaMetrics.smallControlHeight, height: DuplaMetrics.controlHeight)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel(expansion.wrappedValue ? "Replier \(title)" : "Déplier \(title)")
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? DuplaColors.onInk : DuplaColors.text)
        .background {
            if isSelected { DuplaInkSwipe() }
        }
    }
}

public extension DuplaSidebarSection where Actions == EmptyView {
    init(_ title: String, icon: DuplaNavigationIcon.Symbol, isSelected: Bool,
         expansion: Binding<Bool>? = nil, action: @escaping () -> Void) {
        self.init(title, icon: icon, isSelected: isSelected, expansion: expansion, action: action) { EmptyView() }
    }
}

/// A shared submenu row with optional metadata and accessory controls.
public struct DuplaSidebarItem<Actions: View>: View {
    private let title: String
    private let subtitle: String?
    private let isSelected: Bool
    private let action: () -> Void
    private let actions: Actions

    public init(_ title: String, subtitle: String? = nil, isSelected: Bool,
                action: @escaping () -> Void, @ViewBuilder actions: () -> Actions) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.action = action
        self.actions = actions()
    }

    public var body: some View {
        HStack(spacing: 0) {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.subheadline.weight(isSelected ? .medium : .regular))
                        .foregroundStyle(isSelected ? DuplaColors.ink : DuplaColors.mutedText)
                        .lineLimit(1)
                    if let subtitle {
                        Text(subtitle)
                            .duplaTextStyle(.metadata)
                            .foregroundStyle(DuplaColors.mutedText)
                            .lineLimit(1)
                    }
                }
                .padding(DuplaMetrics.small)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .accessibilityAddTraits(isSelected ? [.isSelected] : [])

            actions
                .foregroundStyle(DuplaColors.ink)
                .padding(.trailing, DuplaMetrics.small)
        }
        .buttonStyle(.plain)
        .background(isSelected ? DuplaColors.ink.opacity(0.09) : .clear,
                    in: .rect(cornerRadius: DuplaMetrics.controlRadius))
    }
}

public extension DuplaSidebarItem where Actions == EmptyView {
    init(_ title: String, subtitle: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.init(title, subtitle: subtitle, isSelected: isSelected, action: action) { EmptyView() }
    }
}

#if DEBUG
#Preview("Sections · sélection et actions intégrées") {
    VStack(spacing: DuplaMetrics.extraSmall) {
        DuplaSidebarSection("Versions", icon: .versions, isSelected: true,
                            expansion: .constant(true), action: {}) {
            Menu {
                Button("Nouvelle version…") {}
            } label: {
                Image(systemName: "plus")
                    .frame(width: DuplaMetrics.smallControlHeight, height: DuplaMetrics.controlHeight)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .fixedSize()
        }
        DuplaSidebarSection("Bibliothèque", icon: .library, isSelected: false,
                            expansion: .constant(true), action: {})
        DuplaSidebarSection("Versions", icon: .versions, isSelected: false,
                            expansion: .constant(false), action: {})
    }
    .padding(DuplaMetrics.medium)
    .frame(width: 252)
    .background(DuplaColors.chrome)
}

#Preview("Sous-menus · date et nombre de photos") {
    VStack(spacing: DuplaMetrics.medium) {
        DuplaSidebarItem("Été · lumière douce", subtitle: "11 nov.", isSelected: true, action: {}) {
            Image(systemName: "ellipsis.circle")
        }
        DuplaSidebarItem("Une autre piste", subtitle: "10 nov.", isSelected: false, action: {})
        DuplaSidebarItem("À ajouter", subtitle: "12 photos", isSelected: true, action: {})
        DuplaSidebarItem("Toutes", subtitle: "48 photos", isSelected: false, action: {})
        DuplaSidebarItem("À ajouter", subtitle: "0 photo", isSelected: false, action: {}).disabled(true)
    }
    .padding(DuplaMetrics.section)
    .frame(width: 252)
    .background(DuplaColors.chrome)
}
#endif
