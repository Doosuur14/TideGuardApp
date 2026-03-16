//
//  SafetyViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import UIKit
import MapKit
import Combine

class FloodAnnotation: MKPointAnnotation {
    var floodProbability: Int64 = 0
    var riskLevel: Int = 0
}

class SafetyViewController: UIViewController, MKMapViewDelegate {

    var safetyView: SafetyView?
    let viewModel: SafetyViewModel
    private var cancellables: Set<AnyCancellable> = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFunc()
        configureIO()
        
        viewModel.loadMap()
        viewModel.loadFullFloodMap()
        viewModel.fetchWeather()
        viewModel.fetchFloodForecast()
        viewModel.scheduleDailyForecastReminder()

        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
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
                    
                case .weatherLoaded(let desc, let temp, let humidity,  let precipitation,  let imageUrl, let weeklyForecast):
                    self.updateWeather(desc: desc, temp: temp, humidity: humidity, precipitation: precipitation, imageUrl: imageUrl, weeklyForecast: weeklyForecast)

                case .onMapUpdate(let region):
                    self.safetyView?.mapView.setRegion(region, animated: true)

                case .floodForecastLoaded(let riskDays):
                    self.safetyView?.updateFloodForecastGrid(riskDays)

                case .error:
                    self.safetyView?.hideLoadingSpinner()
                }
            }

            .store(in: &cancellables)
    }



    private func updateAnnotations(_ lgas: [LgaModel]) {
        guard let mapView = safetyView?.mapView else { return }
        mapView.removeAnnotations(mapView.annotations)

        let annotations = lgas.map { lga -> FloodAnnotation in
            var mutableLga = lga
            viewModel.enrichLgaWithComputedFeatures(lga: &mutableLga)
            let risk = viewModel.predictFloodRisk(for: &mutableLga)

            let annotation = FloodAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: lga.latitude,
                longitude: lga.longitude
            )
            annotation.title = lga.lgaName

            annotation.riskLevel = risk
            annotation.floodProbability = mutableLga.floodProbability ?? 0

            let riskLabel = risk == 2 ? "High Risk" :
            risk == 1 ? "Medium Risk" : "Low Risk"
            let probability = mutableLga.floodProbability ?? 0
            annotation.subtitle = "\(riskLabel) · \(probability)% flood probability"

            return annotation
        }

        mapView.addAnnotations(annotations)
    }

    private func addPolygonsToMap(_ polygons: [(MKPolygon, Int)]) {
        guard let mapView = safetyView?.mapView else { return }
        polygons.forEach { mapView.addOverlay($0.0) }
    }

    private func updateWeather(desc: String, temp: Double, humidity: Double, precipitation: Double, imageUrl: String?, weeklyForecast: [WeatherData.DailyForecast]) {
        safetyView?.updateWeather(description: desc, temp: temp, humidity: humidity, precipitation: precipitation, imageUrl: imageUrl)
        safetyView?.updateWeeklyForecast(with: weeklyForecast)
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

        let riskColor: UIColor
        if let floodAnnotation = annotation as? FloodAnnotation {
            switch floodAnnotation.riskLevel {
            case 2:  riskColor = .red
            case 1:  riskColor = .orange
            default: riskColor = .green
            }
        } else {
            riskColor = .gray
        }

        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        context.setFillColor(riskColor.cgColor)
        context.fillEllipse(in: CGRect(x: 3, y: 3, width: 14, height: 14))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        annotationView?.image = image
        return annotationView
    }
}
