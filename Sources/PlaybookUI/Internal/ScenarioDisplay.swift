import SwiftUI

internal struct ScenarioDisplay: View {
    enum Status {
        case `default`
        case waitForSnapshot
        case loaded(image: UIImage)
        case failed

        var isWaitForSnapshot: Bool {
            guard case .waitForSnapshot = self else { return false }
            return true
        }

        var isLoaded: Bool {
            guard case .loaded = self else { return false }
            return true
        }
    }

    static let scale: CGFloat = 0.3

    private var store: ScenarioDisplayStore

    @State
    private var status = Status.default

    @Environment(\.snapshotColorScheme)
    private var snapshotColorScheme

    @Environment(\.galleryDependency)
    private var dependency

    init(store: ScenarioDisplayStore) {
        self.store = store
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Color(.scenarioBackground)

                content()
                    .id(AnimationID.content)
            }
                .compositingGroup()
                .colorScheme(snapshotColorScheme)
                .transition(.opacity)
                .animation(.spring(), value: status.isWaitForSnapshot)
                .frame(
                    width: contentWidth,
                    height: store.snapshotLoader.device.size.height * Self.scale,
                    alignment: .topLeading
                )
                .cornerRadius(12)
                .shadow(color: Color(.black).opacity(0.25), radius: shadowRadius)

            Text(store.data.scenario.name.rawValue)
                .font(.subheadline)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .background(Highlight(store.data.shouldHighlight))
        }
            .frame(width: contentWidth + 16)
            .padding(shadowRadius * 2)
            .onVisibilityChanged(
                in: CGRect(origin: .zero, size: dependency.context.screenSize),
                perform: store.isVisible.send
            )
            .onReceive(store.isVisible.removeDuplicates(by: ==)) { isVisible in
                if isVisible {
                    self.store.loadImage(into: self.$status)
                }
                else {
                    self.store.cancellAll()
                }
            }
    }
}

private extension ScenarioDisplay {
    enum AnimationID {
        case content
    }

    var shadowRadius: CGFloat { 4 }

    var contentWidth: CGFloat {
        store.snapshotLoader.device.size.width * Self.scale
    }

    func content() -> some View {
        switch status {
        case .default, .waitForSnapshot:
            return AnyView(EmptyView())

        case .loaded(let image):
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .frame(
                        width: image.size.width * Self.scale,
                        height: image.size.height * Self.scale
                    )
            )

        case .failed:
            return AnyView(
                Text("Could not load snapshot image")
                    .font(.caption)
                    .bold()
                    .lineLimit(nil)
                    .padding(.horizontal, 8)
            )
        }
    }
}

private extension View {
    func onVisibilityChanged(in bounds: CGRect, perform: @escaping (Bool) -> Void) -> some View {
        background(
            GeometryReader { geometry -> Color in
                let vertical = geometry.size.height / 2
                let insets = UIEdgeInsets.only(top: vertical, bottom: vertical)
                let isVisible =
                    bounds
                    .inset(by: insets)
                    .intersects(geometry.frame(in: .global))
                perform(isVisible)
                return Color.clear
            }
        )
    }
}
