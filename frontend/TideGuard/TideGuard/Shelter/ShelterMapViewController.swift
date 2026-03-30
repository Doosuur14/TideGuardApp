//
//  ShelterMapViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 30.03.2026.
//

import UIKit
import MapKit


protocol SheltersModuleProtocol: AnyObject {
    var viewModel: SheltersViewModel { get set }
}

class ShelterMapViewController: UIViewController, SheltersModuleProtocol,  MKMapViewDelegate {
    var viewModel: SheltersViewModel
    private let mapView = MKMapView()


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shelters"
        view.backgroundColor = .systemBackground

        setupMap()
        bindViewModel()

        viewModel.loadShelters()

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
        mapView.delegate = self
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
        mapView.removeAnnotations(mapView.annotations)

        let annotations = viewModel.shelters.map { shelter -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = shelter.name
            annotation.subtitle = "\(shelter.lga), \(shelter.state)"
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: shelter.latitude,
                longitude: shelter.longitude
            )
            return annotation
        }

        mapView.addAnnotations(annotations)

        // Zoom to first shelter
        if let first = annotations.first {
            mapView.setRegion(
                MKCoordinateRegion(
                    center: first.coordinate,
                    latitudinalMeters: 50000,
                    longitudinalMeters: 50000
                ),
                animated: true
            )
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


}
