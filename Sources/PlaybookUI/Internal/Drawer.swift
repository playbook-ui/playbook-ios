import SwiftUI

internal struct Drawer<Content: View>: View {
    @Binding
    var isOpened: Bool

    var content: Content

    @State
    private var dragState = DragState.inactive

    private var keyboardProxy = KeyboardDismissProxy()

    init(isOpened: Binding<Bool>, content: Content) {
        self._isOpened = isOpened
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Color.black
                    .opacity(self.openingRatio(with: geometry) * 0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture(perform: self.close)

                HStack(alignment: .top, spacing: 0) {
                    self.content
                        .background(self.withShadow(Color.black.edgesIgnoringSafeArea(.all)))
                        .frame(width: self.drawerWidth(with: geometry))

                    self.withShadow(
                        Button(action: self.close) {
                            Image(symbol: .multiply)
                                .imageScale(.medium)
                                .font(Font.title.bold())
                                .foregroundColor(.white)
                                .padding(16)
                        }
                            .opacity(self.openingRatio(with: geometry))
                            .allowsHitTesting(self.isOpened)
                    )

                    Spacer.zero
                }
                    .offset(x: self.offset(with: geometry))
            }
                .animation(nil, value: geometry.size)
                .animation(.interactiveSpring())
                .frame(width: geometry.size.width, height: geometry.size.height)
                .gesture(self.dragGesture(with: geometry))
                .dismissKeyboard(by: self.keyboardProxy)
        }
    }
}

private extension Drawer {
    enum DragState {
        case inactive
        case dragging(translation: CGFloat)
    }

    var shadowRadius: CGFloat { 12 }

    func withShadow<Content: View>(_ content: Content) -> some View {
        content.shadow(color: Color.black.opacity(0.3), radius: shadowRadius)
    }

    func dragGesture(with geometry: GeometryProxy) -> some Gesture {
        let gesture = DragGesture(coordinateSpace: .global)
            .onChanged { drag in
                let isHorizontalDrag = abs(drag.translation.width) >= abs(drag.translation.height)
                self.dragState = isHorizontalDrag ? .dragging(translation: drag.translation.width) : .inactive
                self.keyboardProxy.dismissKeyboard()
            }
            .onEnded { drag in
                let ratio = min(1, max(0, -drag.predictedEndTranslation.width / self.drawerWidth(with: geometry)))
                self.isOpened = ratio <= 0.5
                self.dragState = .inactive
            }
        return isOpened ? gesture : nil
    }

    func close() {
        dragState = .inactive
        isOpened = false
        keyboardProxy.dismissKeyboard()
    }

    func drawerWidth(with geometry: GeometryProxy) -> CGFloat {
        geometry.safeAreaInsets.leading + min(geometry.size.width, geometry.size.height) * 0.8
    }

    func hiddenOffset(with geometry: GeometryProxy) -> CGFloat {
        -drawerWidth(with: geometry) - geometry.safeAreaInsets.leading - shadowRadius
    }

    func offset(with geometry: GeometryProxy) -> CGFloat {
        CGFloat(1 - openingRatio(with: geometry)) * hiddenOffset(with: geometry)
    }

    func openingRatio(with geometry: GeometryProxy) -> Double {
        switch dragState {
        case .inactive:
            return isOpened ? 1 : 0

        case .dragging(let translation):
            let ratio = translation / drawerWidth(with: geometry)
            return Double(min(1, max(0, isOpened ? 1 + ratio : ratio)))
        }
    }
}
