//
//  Untitled.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 27.05.2026.
//


import MapKit

class ReportAnnotation: NSObject, MKAnnotation {
    let report: FloodReport
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(report: FloodReport) {
        self.report = report
        self.coordinate = CLLocationCoordinate2D(
            latitude: report.latitude,
            longitude: report.longitude
        )
        self.title = "Flood Report"
        self.subtitle = report.severity.capitalized
    }

    var markerColor: UIColor {
        switch report.severityLevel {
        case 2:  return .systemRed
        case 1:  return .systemOrange
        default: return .systemYellow
        }
    }
}
