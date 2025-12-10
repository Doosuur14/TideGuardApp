//
//  SafetyViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import UIKit
import MapKit
import Combine



class SafetyViewController: UIViewController, MKMapViewDelegate {

    var safetyView: SafetyView?
    let viewModel: SafetyViewModel
    private var cancellables: Set<AnyCancellable> = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFunc()
        configureIO()
        
        viewModel.loadStateMap()
        viewModel.loadMap()
        viewModel.loadFullFloodMap()

    }

    init(viewModel: SafetyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpFunc() {
        safetyView = SafetyView(frame: view.bounds)
        view  = safetyView
        view.backgroundColor = .systemBackground
        safetyView?.mapView.delegate = self
    }

    private func configureIO() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                    
                case .idle:
                    break
                    
                case .loading:
                    self.safetyView?.showLoadingSpinner()
                    
                case .loadedLGAs(let lgas):
                    self.safetyView?.hideLoadingSpinner()
                    self.updateAnnotations(lgas)
                    
                case .polygonsReady(let polygons):
                    self.addPolygonsToMap(polygons)
                    
                case .weatherLoaded(let desc, let temp, let humidity, let imageUrl):
                    self.updateWeather(desc: desc, temp: temp, humidity: humidity, imageUrl: imageUrl)
                    
                case .onMapUpdate(let region):
                    self.safetyView?.mapView.setRegion(region, animated: true)
                    
                case .error(let message):
                    self.safetyView?.hideLoadingSpinner()
                    self.showError("Failed to load anything")
                }
            }

            .store(in: &cancellables)
    }



    private func updateAnnotations(_ lgas: [LgaModel]) {
        guard let mapView = safetyView?.mapView else { return }

        mapView.removeAnnotations(mapView.annotations)

        let annotations = lgas.map { lga -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lga.latitude, longitude: lga.longitude)
            annotation.title = lga.lgaName

            let risk = viewModel.predictFloodRisk(for: lga)

            annotation.subtitle = (risk == 2 ? "high" : risk == 1 ? "medium" : "low")
            return annotation
        }

        mapView.addAnnotations(annotations)
    }

    private func addPolygonsToMap(_ polygons: [(MKPolygon, Int)]) {
        guard let mapView = safetyView?.mapView else { return }
        polygons.forEach { mapView.addOverlay($0.0) }
    }

    private func updateWeather(desc: String, temp: Double, humidity: Double, imageUrl: String?) {
        safetyView?.weatherDescriptionLabel.text = "Weather: \(desc)"
        safetyView?.temperatureLabel.text = "Temp: \(String(format: "%.1f", temp))°C"
        safetyView?.humidityLabel.text = "Humidity: \(Int(humidity))%"

        safetyView?.updateWeatherImage(with: imageUrl)
    }


    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }



    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else { return nil }

        let identifier = "floodRiskDot"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }


        let risk = annotation.subtitle ?? "low"
        let color: UIColor
        switch risk {
        case "high":
            color = UIColor(red: 0.85, green: 0.05, blue: 0.05, alpha: 1.0)
        case "medium":
            color = UIColor.orange
        default:
            color = UIColor(red: 0.05, green: 0.75, blue: 0.05, alpha: 1.0)
        }


        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!


        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))


        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(x: 3, y: 3, width: 14, height: 14))

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        annotationView?.image = image

        return annotationView
    }
}
