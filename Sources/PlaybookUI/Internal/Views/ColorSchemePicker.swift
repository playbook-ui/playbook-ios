import SwiftUI

@available(iOS 14.0, *)
internal struct ColorSchemePicker: View {
    @Binding
    var colorScheme: ColorScheme?
    @Environment(\.colorScheme)
    private var systemColorScheme

    var body: some View {
        Picker(
            selection: Binding(
                get: { colorScheme ?? systemColorScheme },
                set: { colorScheme = $0 }
            ),
            content: {
                ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
                    switch colorScheme {
                    case .light: Image(symbol: .sunMax)
                    case .dark: Image(symbol: .moon)
                    @unknown default: EmptyView()
                    }
                }
            },
            label: {
                EmptyView()
            }
        )
        .pickerStyle(.segmented)
        .fixedSize()
    }
}
