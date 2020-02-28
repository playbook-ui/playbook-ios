import SwiftUI
import UIKit

internal struct SearchBar: UIViewRepresentable {
    @Binding
    var text: String?

    var placeholder: String?
    var updateUIView: ((UISearchBar) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.backgroundImage = UIImage()
        searchBar.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 0), for: .clear)
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.delegate = context.coordinator
        updateUIView?(uiView)
    }
}

internal extension SearchBar {
    final class Coordinator: NSObject, UISearchBarDelegate {
        let searchBar: SearchBar

        init(_ searchBar: SearchBar) {
            self.searchBar = searchBar
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchBar.text = searchText
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
}
