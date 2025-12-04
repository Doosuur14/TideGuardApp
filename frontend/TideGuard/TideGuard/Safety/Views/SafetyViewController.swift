//
//  SafetyViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import UIKit
import MapKit

class SafetyViewController: UIViewController, MKMapViewDelegate {

    var safetyView: SafetyView?
    let viewModel: SafetyViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFunc()
        configureIO()

        viewModel.loadStateMap()
        viewModel.loadMap()
        viewModel.loadFullFloodMap()
        viewModel.fetchWeather()
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

        if viewModel.onFloodLgaUpdate == nil {
            print("CRITICAL: onFloodLgaUpdate callback is NIL")
        } else {
            print("onFloodLgaUpdate callback is connected")
        }

        if viewModel.onGeoJsonPolygonsReady == nil {
            print("CRITICAL: onGeoJsonPolygonsReady callback is NIL")
        } else {
            print("onGeoJsonPolygonsReady callback is connected")
        }


        viewModel.onMapUpdate = { [weak self] region in
            print("MAP UPDATE CALLBACK FIRED")
            print("Center: \(region.center.latitude), \(region.center.longitude)")
            print("Span: \(region.span.latitudeDelta), \(region.span.longitudeDelta)")
            self?.safetyView?.mapView.setRegion(region, animated: true)
            print("MAP REGION SET SUCCESSFULLY")
        }

        viewModel.onGeoJsonPolygonsReady = { [weak self] polygonsWithRisk in

            guard let mapView = self?.safetyView?.mapView else { return }

            print("ADDING \(polygonsWithRisk.count) POLYGONS TO MAP")

            for (polygon, risk) in polygonsWithRisk {
                print("Adding polygon with risk: \(risk)")
                mapView.addOverlay(polygon)
            }

            print("ALL POLYGONS ADDED TO MAP")

        }


        viewModel.onFloodLgaUpdate = { [weak self] lgas in
            print("Received \(lgas.count) LGAs with flood risk")
            guard let mapView = self?.safetyView?.mapView else { return }

            mapView.removeAnnotations(mapView.annotations)

            var annotations: [MKPointAnnotation] = []

            for lga in lgas {
                let risk = self?.viewModel.predictFloodRisk(for: lga) ?? 0

                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lga.latitude, longitude: lga.longitude)
                annotation.title = lga.lgaName


                switch risk {
                case 2:
                    annotation.subtitle = "high"
                case 1:
                    annotation.subtitle = "medium"
                default:
                    annotation.subtitle = "low"
                }

                annotations.append(annotation)
            }

            DispatchQueue.main.async {
                mapView.addAnnotations(annotations)
            }
        }


        viewModel.onSheltersUpdate = { [weak self]  annotations in
            guard let mapView = self?.safetyView?.mapView else { return }
            mapView.addAnnotations(annotations)

        }
        viewModel.onWeatherUpdate = { [weak self] description, temperature, humidity, imageURL in
            print("Updating weather UI - Description: \(description), Temp: \(temperature), Humidity: \(humidity), Image: \(imageURL ?? "None")")
            self?.safetyView?.weatherDescriptionLabel.text = "Weather: \(description)"
            self?.safetyView?.temperatureLabel.text = "Temp: \(String(format: "%.1f", temperature))°C"
            self?.safetyView?.humidityLabel.text = "Humidity: \(String(format: "%.0f", humidity))%"
            self?.safetyView?.updateWeatherImage(with: imageURL)
        }
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
