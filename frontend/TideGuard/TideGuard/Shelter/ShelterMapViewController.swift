//
//  ShelterMapViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 30.03.2026.
//

//import UIKit
//import MapKit


//protocol SheltersModuleProtocol: AnyObject {
//    var viewModel: SheltersViewModel { get set }
//}
//
//class ShelterMapViewController: UIViewController, SheltersModuleProtocol,  MKMapViewDelegate {
//    var viewModel: SheltersViewModel
//    private let mapView = MKMapView()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//        setupMap()
//        bindViewModel()
//
//        viewModel.loadShelters()
//
//    }
//
//    init(viewModel: SheltersViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupMap() {
//        view.addSubview(mapView)
//        mapView.frame = view.bounds
//        mapView.delegate = self
//        mapView.mapType = .mutedStandard
//    }
//
//    private func bindViewModel() {
//        viewModel.onSheltersUpdated = { [weak self] in
//            self?.updateMapAnnotations()
//        }
//
//        viewModel.onError = { [weak self] message in
//            self?.showError(message)
//        }
//    }
//
//    private func updateMapAnnotations() {
//        mapView.removeAnnotations(mapView.annotations)
//
//        let annotations = viewModel.shelters.map { shelter -> MKPointAnnotation in
//            let annotation = MKPointAnnotation()
//            annotation.title = shelter.name
//            annotation.subtitle = "\(shelter.lga), \(shelter.city)"
//            annotation.coordinate = CLLocationCoordinate2D(
//                latitude: shelter.latitude,
//                longitude: shelter.longitude
//            )
//            return annotation
//        }
//
//        mapView.addAnnotations(annotations)
//
//       
//        if let first = annotations.first {
//            mapView.setRegion(
//                MKCoordinateRegion(
//                    center: first.coordinate,
//                    latitudinalMeters: 50000,
//                    longitudinalMeters: 50000
//                ),
//                animated: true
//            )
//        }
//    }
//
//    private func showError(_ message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}






import UIKit
import MapKit

protocol SheltersModuleProtocol: AnyObject {
    var viewModel: SheltersViewModel { get set }
}

class ShelterAnnotation: NSObject, MKAnnotation {
    let shelter: Shelter
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(shelter: Shelter) {
        self.shelter = shelter
        self.coordinate = CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude)
        self.title = shelter.name

        if let distance = shelter.distanceKm {
            self.subtitle = "\(shelter.lga), \(shelter.city) • \(String(format: "%.1f", distance))km away"
        } else {
            self.subtitle = "\(shelter.lga), \(shelter.city)"
        }
    }
}

class ShelterMapViewController: UIViewController, SheltersModuleProtocol, MKMapViewDelegate {
    var viewModel: SheltersViewModel
    private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Emergency Shelters"

        setupMap()
        bindViewModel()


        if let userLocation = LocationService.shared.getCurrentLocation() {
            print("Loading nearest shelters from user location")
            viewModel.loadNearestShelters(userLocation: userLocation, limit: 20)
        } else {
            print("No user location, loading by state")
            viewModel.loadShelters()
        }
    }

    init(viewModel: SheltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMap() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = true
    }

    private func bindViewModel() {
        viewModel.onSheltersUpdated = { [weak self] in
            self?.updateMapAnnotations()
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func updateMapAnnotations() {
        let oldAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(oldAnnotations)

        let annotations = viewModel.shelters.map { shelter -> ShelterAnnotation in
            return ShelterAnnotation(shelter: shelter)
        }

        mapView.addAnnotations(annotations)
        print("✅ Added \(annotations.count) shelter annotations to map")


        if !annotations.isEmpty {
            mapView.showAnnotations(annotations, animated: true)

            // Add some padding so markers aren't at the edges
            let edgePadding = UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40)
            mapView.layoutMargins = edgePadding
        }
    }


//    private func updateMapAnnotations() {
//
//        let oldAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
//        mapView.removeAnnotations(oldAnnotations)
//
//
//        let annotations = viewModel.shelters.map { shelter -> ShelterAnnotation in
//            return ShelterAnnotation(shelter: shelter)
//        }
//
//        mapView.addAnnotations(annotations)
//
//        print("✅ Added \(annotations.count) shelter annotations to map")
//
//
//        if let userLocation = LocationService.shared.getCurrentLocation() {
//            mapView.setRegion(
//                MKCoordinateRegion(
//                    center: userLocation,
//                    latitudinalMeters: 100000,
//                    longitudinalMeters: 100000
//                ),
//                animated: true
//            )
//        } else if let first = annotations.first {
//            mapView.setRegion(
//                MKCoordinateRegion(
//                    center: first.coordinate,
//                    latitudinalMeters: 100000,
//                    longitudinalMeters: 100000
//                ),
//                animated: true
//            )
//        }
//    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }


        if let cluster = annotation as? MKClusterAnnotation {
            let identifier = "ShelterCluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if clusterView == nil {
                clusterView = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: identifier)
            }

            clusterView?.annotation = cluster
            clusterView?.markerTintColor = UIColor(named: "MainColor") ?? .systemBlue
            clusterView?.glyphText = "\(cluster.memberAnnotations.count)"
            return clusterView
        }

        guard let shelterAnnotation = annotation as? ShelterAnnotation else {
            return nil
        }

        let identifier = "ShelterMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true


            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton


            annotationView?.markerTintColor = UIColor(named: "MainColor") ?? .systemBlue
            annotationView?.glyphImage = UIImage(systemName: "house.fill")

            annotationView?.clusteringIdentifier = "shelterCluster"

        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let shelterAnnotation = view.annotation as? ShelterAnnotation else { return }
        showShelterActionSheet(for: shelterAnnotation.shelter)
    }


    private func showShelterActionSheet(for shelter: Shelter) {
        let distanceText = shelter.distanceKm != nil ? "\n📍 Distance: \(String(format: "%.1f", shelter.distanceKm!))km" : ""

        let alert = UIAlertController(
            title: shelter.name,
            message: "\(shelter.displayAddress)\n\(shelter.lga), \(shelter.city)\(distanceText)\n\nType: \(shelter.typeDisplayName)\nCapacity: \(shelter.capacityFormatted) people",
            preferredStyle: .actionSheet
        )

        // Get Directions
        alert.addAction(UIAlertAction(title: "Get directions", style: .default) { [weak self] _ in
            self?.openInAppleMaps(shelter: shelter)
        })

        // Call (if available)
        if let phone = shelter.phoneNumber, !phone.isEmpty {
            alert.addAction(UIAlertAction(title: "Call: \(phone)", style: .default) { [weak self] _ in
                self?.callShelter(phone: phone)
            })
        }


        alert.addAction(UIAlertAction(title: "Share location", style: .default) { [weak self] _ in
            self?.shareShelterLocation(shelter: shelter)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))


        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        present(alert, animated: true)
    }

    private func openInAppleMaps(shelter: Shelter) {
        let coordinate = CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shelter.name

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]

        mapItem.openInMaps(launchOptions: launchOptions)
        print("Opening Apple Maps for: \(shelter.name)")
    }

    private func callShelter(phone: String) {
        let cleanedPhone = phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")

        if let url = URL(string: "tel://\(cleanedPhone)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print("📞 Calling: \(phone)")
            } else {
                showError("Cannot make phone calls on this device")
            }
        }
    }

    private func shareShelterLocation(shelter: Shelter) {
        let distanceText = shelter.distanceKm != nil ? "\n📏 Расстояние: \(String(format: "%.1f", shelter.distanceKm!))км" : ""

        let text = """
        🏠 Убежище: \(shelter.name)
        📍 \(shelter.displayAddress)
        🏙️ \(shelter.lga), \(shelter.city)
        👥 Вместимость: \(shelter.capacityFormatted) человек\(distanceText)
        """

        let mapsURL = "https://maps.apple.com/?q=\(shelter.latitude),\(shelter.longitude)"

        let activityVC = UIActivityViewController(
            activityItems: [text, mapsURL],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
}
