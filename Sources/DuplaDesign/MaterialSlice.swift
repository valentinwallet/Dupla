import SwiftUI

struct MaterialSlice: View {
    enum Material: String {
        case inkBrush = "InkBrush"
        case kraftTape = "KraftTape"

        // Normalized bounds of the artwork inside each transparent scan.
        var artwork: CGRect {
            switch self {
            case .inkBrush: CGRect(x: 33.0 / 2172, y: 214.0 / 724, width: 2090.0 / 2172, height: 304.0 / 724)
            case .kraftTape: CGRect(x: 67.0 / 2172, y: 168.0 / 724, width: 2044.0 / 2172, height: 383.0 / 724)
            }
        }
    }

    private let material: Material

    init(_ material: Material) {
        self.material = material
    }

    var body: some View {
        GeometryReader { proxy in
            let artwork = material.artwork
            let width = proxy.size.width / artwork.width
            let height = proxy.size.height / artwork.height

            Image(material.rawValue, bundle: .module)
                .resizable()
                .interpolation(.high)
                .frame(width: width, height: height)
                .offset(x: -artwork.minX * width, y: -artwork.minY * height)
        }
        .clipped()
    }
}
