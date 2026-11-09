import SwiftUI

public enum DuplaPhotoContour: CaseIterable {
    case freehand
    case doubleStroke
    case loop

    public static func random(excluding previous: Self? = nil) -> Self {
        allCases.filter { $0 != previous }.randomElement() ?? .freehand
    }

    fileprivate var sketch: SketchShape.Kind {
        switch self {
        case .freehand: .photoFreehand
        case .doubleStroke: .photoDoubleStroke
        case .loop: .photoLoop
        }
    }
}

public struct DuplaPhotoFrame<Content: View>: View {
    private let contour: DuplaPhotoContour?
    private let content: Content

    public init(contour: DuplaPhotoContour? = nil, @ViewBuilder content: () -> Content) {
        self.contour = contour
        self.content = content()
    }

    public var body: some View {
        content
            .clipped()
            .overlay {
                if let contour {
                    DuplaColors.ink
                        .mask {
                            Image("InkGrain", bundle: .module)
                                .resizable()
                                .brightness(-0.25)
                                .contrast(2)
                                .luminanceToAlpha()
                                .mask {
                                    SketchStroke(contour.sketch, lineWidth: 3.5)
                                }
                        }
                        .padding(-DuplaMetrics.small)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
    }
}

#if DEBUG
#Preview("Contours de sélection Dupla") {
    VStack(spacing: DuplaMetrics.section) {
        ForEach(DuplaPhotoContour.allCases, id: \.self) { contour in
            HStack(spacing: DuplaMetrics.extraSmall) {
                Rectangle().fill(DuplaColors.lavender)
                    .frame(width: 58, height: 74)

                DuplaPhotoFrame(contour: contour) {
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(DuplaColors.ink)
                        .frame(width: 110, height: 74)
                        .background(DuplaColors.tapeKraft.opacity(0.3))
                }
                .zIndex(1)

                Rectangle().fill(DuplaColors.lavender)
                    .frame(width: 58, height: 74)
            }
        }
    }
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
