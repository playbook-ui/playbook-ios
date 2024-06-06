import Playbook
import SwiftUI

@available(iOS 15.0, *)
internal struct GalleryThumbnail: View {
    let data: SearchedData

    @State
    private var image: UIImage?
    @EnvironmentObject
    private var imageLoader: ImageLoader
    @Environment(\.colorScheme)
    private var colorScheme
    private let contentScale: CGFloat = 0.3
    private let imageScale: CGFloat = 0.5
    private let screenSize = UIScreen.main.fixedCoordinateSpace.bounds.size
    private let cornerRadius: CGFloat = 16

    var body: some View {
        ZStack {
            Color(.background)

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .frame(
                        width: image.size.width * contentScale / imageScale,
                        height: image.size.height * contentScale / imageScale
                    )
            }
            else {
                Placeholder()
            }
        }
        .frame(width: contentWidth, height: contentHeight, alignment: .top)
        .overlay(alignment: .bottom) {
            NameLabel(data: data)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Color(.systemGray5), lineWidth: 4)
        }
        .cornerRadius(cornerRadius)
        .padding(4)
        .onChange(of: colorScheme) { _ in
            image = nil
        }
        .task(id: colorScheme, priority: .background) {
            let source = ImageSource(
                scenario: data.scenario,
                category: data.category,
                size: screenSize,
                scale: imageScale,
                colorScheme: colorScheme
            )
            image = await imageLoader.loadImage(for: source)
        }
    }
}

@available(iOS 15, *)
private struct NameLabel: View {
    let data: SearchedData

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .ignoresSafeArea()

            HighlightText(
                content: data.scenario.title.rawValue,
                range: data.highlightRange
            )
            .textStyle(font: .caption)
            .minimumScaleFactor(0.1)
            .padding(.top, 4)
            .padding([.bottom, .horizontal], 8)
            .frame(maxWidth: .infinity)
        }
        .background {
            MaterialView()
        }
    }
}

private struct Placeholder: View {
    @State
    private var isAnimating = false

    var body: some View {
        Color(.translucentFill)
            .opacity(isAnimating ? 1 : 0)
            .animation(
                .linear(duration: 0.5)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                if !isAnimating {
                    isAnimating = true
                }
            }
    }
}

@available(iOS 15.0, *)
private extension GalleryThumbnail {
    var contentWidth: CGFloat {
        screenSize.width * contentScale
    }

    var contentHeight: CGFloat {
        screenSize.height * contentScale
    }
}
