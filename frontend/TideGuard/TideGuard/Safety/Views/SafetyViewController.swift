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
        viewModel.loadEvacuationData()
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
            print("❌ CRITICAL: onFloodLgaUpdate callback is NIL")
        } else {
            print("✅ onFloodLgaUpdate callback is connected")
        }

        if viewModel.onGeoJsonPolygonsReady == nil {
            print("❌ CRITICAL: onGeoJsonPolygonsReady callback is NIL")
        } else {
            print("✅ onGeoJsonPolygonsReady callback is connected")
        }

//        viewModel.onMapUpdate = { [weak self] region in
//            self?.safetyView?.mapView.setRegion(region, animated: true)
//        }
        viewModel.onMapUpdate = { [weak self] region in
            print("🗺️ MAP UPDATE CALLBACK FIRED")
            print("   Center: \(region.center.latitude), \(region.center.longitude)")
            print("   Span: \(region.span.latitudeDelta), \(region.span.longitudeDelta)")
            self?.safetyView?.mapView.setRegion(region, animated: true)
            print("✅ MAP REGION SET SUCCESSFULLY")
        }

        viewModel.onGeoJsonPolygonsReady = { [weak self] polygonsWithRisk in
//            guard let mapView = self?.safetyView?.mapView else { return }
//
//            for (polygon, risk) in polygonsWithRisk {
//                mapView.addOverlay(polygon)
//            }

            guard let mapView = self?.safetyView?.mapView else { return }

            print("🎯 ADDING \(polygonsWithRisk.count) POLYGONS TO MAP")

            for (polygon, risk) in polygonsWithRisk {
                print("   🟦 Adding polygon with risk: \(risk)")
                mapView.addOverlay(polygon)
            }

            print("✅ ALL POLYGONS ADDED TO MAP")

        }


        viewModel.onFloodLgaUpdate = { [weak self] lgas in
            print("Received \(lgas.count) LGAs")
            guard let mapView = self?.safetyView?.mapView else { return }

            print("calling lga flood")

            for lga in lgas {
                let risk = self?.viewModel.predictFloodRisk(for: lga) ?? 0
                print("Adding circle for \(lga.lgaName): risk \(risk), coord \(lga.latitude),\(lga.longitude)")

                let color: UIColor
                switch risk {
                case 0: color = .green
                case 1: color = .orange
                case 2: color = .red
                default: color = .gray
                }

                let center = CLLocationCoordinate2D(latitude: lga.latitude, longitude: lga.longitude)
                let circle = MKCircle(center: center, radius: 7000)
                circle.title = "\(risk)"

                mapView.addOverlay(circle)
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



    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {



        // Handle Polygons (from GeoJSON)
        if let polygon = overlay as? MKPolygon,
           let riskString = polygon.title,
           let risk = Int(riskString) {
            print("Renderer called for overlay: \(String(describing: overlay.title ?? "unknown")) with risk \(risk)")

            let renderer = MKPolygonRenderer(polygon: polygon)

            switch risk {
            case 2: renderer.fillColor = UIColor.red.withAlphaComponent(0.7)
            case 1: renderer.fillColor = UIColor.orange.withAlphaComponent(0.7)
            default: renderer.fillColor = UIColor.green.withAlphaComponent(0.7)
            }

            renderer.lineWidth = 1
            return renderer
        }

      
        if let circle = overlay as? MKCircle,
           let riskString = circle.title,
           let risk = Int(riskString) {

            let renderer = MKCircleRenderer(circle: circle)

            switch risk {
            case 2:
                renderer.fillColor = UIColor.red.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.red
            case 1:
                renderer.fillColor = UIColor.orange.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.orange
            default:
                renderer.fillColor = UIColor.green.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.green
            }

            renderer.lineWidth = 2
            return renderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }


    private func addTestOverlay() {
        print("🧪 ADDING TEST OVERLAY")
        let testCoordinate = CLLocationCoordinate2D(latitude: 6.5244, longitude: 3.3792)
        let testCircle = MKCircle(center: testCoordinate, radius: 10000) // 10km radius
        testCircle.title = "2" // High risk
        safetyView?.mapView.addOverlay(testCircle)
        print("✅ TEST OVERLAY ADDED - Should see a red circle in Lagos")
    }
}

