/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts an `MKMapView`.
*/

import SwiftUI
import MapKit

public struct MapView: UIViewRepresentable {
    final public class Coordinator: NSObject, MKMapViewDelegate {
        public var base: MapView

        public init(base: MapView) {
            self.base = base
        }

        public func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
            base.didFinishRendering?()
        }
    }

    public var coordinate: CLLocationCoordinate2D
    public var didFinishRendering: (() -> Void)?

    public static func dismantleUIView(_ uiView: MKMapView, coordinator: Void) {
        uiView.removeAnnotations(uiView.annotations)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(base: self)
    }

    public func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    public func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        view.delegate = context.coordinator
    }

    public init(
        coordinate: CLLocationCoordinate2D,
        didFinishRendering: (() -> Void)? = nil
    ) {
        self.coordinate = coordinate
        self.didFinishRendering = didFinishRendering
    }
}

internal struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: landmarkData[0].locationCoordinate)
    }
}
