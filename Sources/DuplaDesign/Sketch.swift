import SwiftUI

public struct DuplaAnnotation: View {
    public enum Mark {
        case arrow
        case circle
        case doubleUnderline
        case bracket

        fileprivate var sketch: SketchShape.Kind {
            switch self {
            case .arrow: .arrow
            case .circle: .circle
            case .doubleUnderline: .doubleUnderline
            case .bracket: .bracket
            }
        }
    }

    private let mark: Mark

    public init(_ mark: Mark) {
        self.mark = mark
    }

    public var body: some View {
        SketchStroke(mark.sketch, lineWidth: 2)
    }
}

public extension View {
    /// Draws a mark relative to this view's bounds.
    func duplaAnnotation(_ mark: DuplaAnnotation.Mark) -> some View {
        modifier(DuplaAnnotationModifier(mark: mark))
    }
}

private struct DuplaAnnotationModifier: ViewModifier {
    let mark: DuplaAnnotation.Mark

    @ViewBuilder
    func body(content: Content) -> some View {
        switch mark {
        case .arrow:
            content.overlay(alignment: .topTrailing) {
                DuplaAnnotation(mark)
                    .frame(width: 62, height: 30)
                    .offset(x: 51, y: -24)
            }
        case .circle:
            content.overlay {
                DuplaAnnotation(mark)
                    .padding(.horizontal, -DuplaMetrics.small)
                    .padding(.vertical, -DuplaMetrics.extraSmall)
            }
        case .doubleUnderline:
            content.overlay(alignment: .bottom) {
                DuplaAnnotation(mark)
                    .frame(height: 6)
                    .offset(y: 5)
            }
        case .bracket:
            content.overlay(alignment: .leading) {
                DuplaAnnotation(mark)
                    .frame(width: 10)
                    .padding(.vertical, -DuplaMetrics.extraSmall)
                    .offset(x: -14)
            }
        }
    }
}

public struct DuplaDoodle: View {
    public enum Motif {
        case sun
        case flower
        case bird
        case sprout
        case rainCloud
        case smiley

        fileprivate var sketch: SketchShape.Kind {
            switch self {
            case .sun: .sun
            case .flower: .flower
            case .bird: .bird
            case .sprout: .sprout
            case .rainCloud: .rainCloud
            case .smiley: .smiley
            }
        }
    }

    private let motif: Motif

    public init(_ motif: Motif) {
        self.motif = motif
    }

    public var body: some View {
        SketchStroke(motif.sketch, lineWidth: 2)
            .aspectRatio(100.0 / 64.0, contentMode: .fit)
    }
}

struct SketchStroke: View {
    private let kind: SketchShape.Kind
    private let color: Color
    private let lineWidth: CGFloat

    init(_ kind: SketchShape.Kind, color: Color = DuplaColors.ink, lineWidth: CGFloat = 1.5) {
        self.kind = kind
        self.color = color
        self.lineWidth = lineWidth
    }

    var body: some View {
        SketchShape(kind: kind)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .padding(lineWidth / 2)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

struct SketchShape: Shape {
    enum Kind {
        case arrow, circle, doubleUnderline, bracket, singleUnderline, stamp
        case sun, flower, bird, sprout, rainCloud, smiley
        case photoFreehand, photoDoubleStroke, photoLoop
    }

    let kind: Kind

    func path(in rect: CGRect) -> Path {
        Path { path in
            switch kind {
            case .arrow:
                path.move(95, 14)
                path.curve(6, 56, via: 75, -6, 35, 9)
                path.move(16, 28)
                path.line(6, 56)
                path.line(27, 49)
            case .circle:
                path.move(63, 10)
                path.curve(7, 44, via: 34, 0, -3, 20)
                path.curve(90, 51, via: 18, 67, 75, 65)
                path.curve(51, 12, via: 119, 23, 84, 5)
            case .doubleUnderline:
                path.move(3, 22)
                path.curve(97, 15, via: 26, 10, 78, 22)
                path.move(9, 53)
                path.curve(93, 43, via: 32, 45, 70, 47)
            case .bracket:
                path.move(91, 4)
                path.curve(19, 7, via: 66, 3, 35, 6)
                path.curve(18, 61, via: 11, 20, 21, 44)
                path.line(83, 59)
            case .singleUnderline:
                path.move(2, 45)
                path.curve(98, 38, via: 23, 3, 74, 60)
            case .stamp:
                path.move(1, 5)
                path.curve(98, 4, via: 32, 0, 71, 3)
                path.curve(99, 59, via: 100, 20, 98, 47)
                path.curve(2, 60, via: 71, 62, 25, 63)
                path.curve(1, 5, via: 0, 50, 2, 20)
            case .smiley:
                path.move(34, 21)
                path.line(36, 26)
                path.move(56, 18)
                path.line(57, 24)
                path.move(27, 39)
                path.curve(70, 35, via: 39, 54, 57, 56)
            case .photoFreehand:
                path.move(1, 2)
                path.curve(100, 1, via: 32, 3, 72, -1)
                path.move(98, 0)
                path.curve(100, 63, via: 101, 25, 97, 48)
                path.move(101, 61)
                path.curve(0, 63, via: 75, 63, 34, 60)
                path.move(2, 64)
                path.curve(2, 0, via: -1, 49, 0, 20)
            case .photoDoubleStroke:
                path.move(10, 5)
                path.curve(90, 3, via: 39, 1, 70, 2)
                path.curve(96, 12, via: 94, 3, 96, 6)
                path.curve(92, 60, via: 98, 30, 94, 55)
                path.curve(5, 59, via: 70, 62, 25, 63)
                path.curve(4, 13, via: 2, 52, 2, 26)
                path.curve(11, 7, via: 4, 7, 6, 6)
                path.move(10, 9)
                path.curve(97, 6, via: 44, 7, 71, 2)
                path.curve(94, 55, via: 99, 21, 95, 40)
                path.curve(13, 62, via: 66, 56, 42, 63)
                path.curve(8, 9, via: 9, 50, 10, 27)
            case .photoLoop:
                path.move(89, 58)
                path.curve(11, 58, via: 67, 64, 22, 68)
                path.curve(8, 17, via: 1, 52, 1, 29)
                path.curve(76, 2, via: 19, 5, 54, 1)
                path.curve(92, 54, via: 108, 0, 97, 27)
                path.curve(106, 51, via: 95, 54, 103, 50)
            case .sun:
                path.move(49, 15)
                path.curve(36, 22, via: 43, 10, 35, 14)
                path.curve(51, 23, via: 39, 32, 50, 29)
                path.curve(49, 15, via: 53, 19, 51, 17)
                for ray in [
                    (41.0, 3.0, 42.0, 8.0), (58, 8, 54, 12), (64, 20, 59, 20),
                    (55, 33, 57, 37), (38, 32, 35, 37), (24, 24, 30, 23), (29, 8, 34, 12),
                ] {
                    path.move(ray.0, ray.1)
                    path.line(ray.2, ray.3)
                }
                path.move(5, 54)
                path.curve(49, 53, via: 25, 42, 30, 42)
                path.move(31, 61)
                path.curve(95, 52, via: 65, 47, 64, 38)
            case .flower:
                path.move(45, 21)
                path.curve(30, 9, via: 34, 24, 23, 16)
                path.curve(46, 16, via: 34, 4, 41, 7)
                path.curve(60, 8, via: 47, 7, 55, 4)
                path.curve(55, 20, via: 64, 11, 63, 16)
                path.curve(68, 27, via: 66, 17, 74, 24)
                path.curve(54, 29, via: 64, 31, 58, 31)
                path.curve(46, 37, via: 59, 37, 51, 42)
                path.curve(43, 28, via: 42, 35, 41, 31)
                path.curve(30, 28, via: 36, 35, 28, 32)
                path.curve(44, 21, via: 28, 22, 36, 20)
                path.move(47, 20)
                path.curve(50, 27, via: 42, 22, 44, 29)
                path.curve(47, 20, via: 56, 24, 53, 18)
                path.move(50, 38)
                path.curve(44, 61, via: 54, 47, 47, 54)
                path.move(50, 52)
                path.curve(69, 40, via: 57, 43, 62, 44)
                path.curve(50, 52, via: 65, 48, 57, 50)
            case .bird:
                path.move(30, 29)
                path.curve(48, 25, via: 38, 19, 45, 21)
                path.curve(71, 14, via: 55, 12, 65, 11)
                path.move(12, 53)
                path.curve(89, 52, via: 44, 48, 59, 55)
            case .sprout:
                path.move(13, 57)
                path.curve(88, 54, via: 43, 47, 55, 59)
                path.move(48, 54)
                path.curve(55, 26, via: 47, 45, 54, 38)
                path.curve(68, 13, via: 52, 18, 61, 16)
                path.curve(55, 26, via: 64, 23, 61, 24)
                path.move(51, 39)
                path.curve(34, 31, via: 46, 29, 40, 27)
                path.curve(51, 39, via: 40, 33, 43, 44)
            case .rainCloud:
                path.move(34, 22)
                path.curve(26, 38, via: 19, 18, 15, 32)
                path.curve(45, 39, via: 32, 41, 39, 40)
                path.curve(65, 37, via: 51, 44, 61, 43)
                path.curve(82, 30, via: 76, 42, 85, 37)
                path.curve(68, 21, via: 80, 25, 75, 21)
                path.curve(34, 22, via: 67, 5, 39, 5)
                path.move(44, 47)
                path.curve(42, 57, via: 41, 53, 39, 57)
                path.curve(44, 47, via: 48, 58, 46, 51)
                path.move(62, 44)
                path.curve(62, 53, via: 60, 48, 58, 52)
                path.curve(62, 44, via: 67, 53, 65, 49)
            }
        }
        .applying(CGAffineTransform(
            a: rect.width / 100, b: 0, c: 0, d: rect.height / 64, tx: rect.minX, ty: rect.minY
        ))
    }
}

private extension Path {
    mutating func move(_ x: CGFloat, _ y: CGFloat) {
        move(to: CGPoint(x: x, y: y))
    }

    mutating func line(_ x: CGFloat, _ y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }

    mutating func curve(
        _ x: CGFloat, _ y: CGFloat, via x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat
    ) {
        addCurve(
            to: CGPoint(x: x, y: y),
            control1: CGPoint(x: x1, y: y1),
            control2: CGPoint(x: x2, y: y2)
        )
    }
}

#if DEBUG
#Preview("Annotations Dupla") {
    let marks: [(String, DuplaAnnotation.Mark)] = [
        ("Flèche", .arrow), ("Cercle", .circle),
        ("Double trait", .doubleUnderline), ("Crochet", .bracket),
    ]

    VStack(alignment: .leading, spacing: DuplaMetrics.section) {
        ForEach(marks.indices, id: \.self) { index in
            let (name, mark) = marks[index]

            HStack(spacing: DuplaMetrics.section) {
                Text(name)
                    .frame(width: 110, alignment: .leading)

                if mark == .bracket {
                    Text("Voir la version")
                        .duplaAnnotation(.bracket)
                } else {
                    HStack(alignment: .firstTextBaseline, spacing: DuplaMetrics.small) {
                        Text("Voir la")
                        Text("version")
                            .duplaAnnotation(mark)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            .duplaTextStyle(.label)
        }
    }
    .foregroundStyle(DuplaColors.text)
    .padding(.trailing, 52)
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}

#Preview("Dessins Dupla") {
    let motifs: [(String, DuplaDoodle.Motif)] = [
        ("Soleil", .sun), ("Fleur", .flower), ("Oiseau", .bird),
        ("Pousse", .sprout), ("Nuage", .rainCloud), ("Smiley", .smiley),
    ]

    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: DuplaMetrics.large) {
        ForEach(motifs.indices, id: \.self) { index in
            VStack(spacing: DuplaMetrics.small) {
                DuplaDoodle(motifs[index].1)
                    .frame(width: 88, height: 58)
                Text(motifs[index].0)
                    .duplaTextStyle(.caption)
            }
        }
    }
    .frame(width: 300)
    .foregroundStyle(DuplaColors.text)
    .padding(DuplaMetrics.section)
    .background(DuplaColors.paper)
}
#endif
