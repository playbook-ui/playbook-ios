import SwiftUI

internal final class KeyboardDismissProxy {
    fileprivate weak var uiView: UIView?

    func dismissKeyboard() {
        uiView?.window?.endEditing(true)
    }

    init() {}
}

internal extension View {
    func dismissKeyboard(by proxy: KeyboardDismissProxy) -> some View {
        background(
            HiddenView(proxy: proxy)
                .frame(width: 0, height: 0)
                .fixedSize()
                .opacity(0)
                .allowsHitTesting(false)
        )
    }
}

private struct HiddenView: UIViewRepresentable {
    var proxy: KeyboardDismissProxy

    init(proxy: KeyboardDismissProxy) {
        self.proxy = proxy
    }

    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        uiView.backgroundColor = .clear
        uiView.isHidden = true
        uiView.isUserInteractionEnabled = false
        return uiView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        proxy.uiView = uiView
    }
}
