//
//  SafetyView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import UIKit
import MapKit
import SnapKit

class SafetyView: UIView {
    lazy var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Map","Weather"])
    lazy var containerView: UIView = UIView()
    lazy var mapView: MKMapView = MKMapView()
    lazy var weatherContainer: UIView = UIView()
    lazy var weatherImageView: UIImageView = UIImageView()
    lazy var weatherDescriptionLabel: UILabel = UILabel()
    lazy var temperatureLabel: UILabel = UILabel()
    lazy var humidityLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFunc()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFunc() {
        setUpSegments()
        setUpContainer()
        setUpMap()
        addLegend(to:mapView)
        setUpLegendView()
        setUpWeatherContainer()

    }

    private func setUpSegments() {
        addSubview(segmentedControl)
        segmentedControl.backgroundColor = UIColor(named: "Color")
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "MainColor") as Any], for: .selected)
        segmentedControl.addTarget(self, action: #selector(switchSection), for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func setUpContainer() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    private func setUpMap() {
        containerView.addSubview(mapView)
        mapView.isHidden = false
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }

    private func setUpLegendView() {
        let legendView = UIStackView()
        legendView.axis = .horizontal
        legendView.alignment = .center
        legendView.spacing = 16
        legendView.distribution = .equalSpacing
        legendView.translatesAutoresizingMaskIntoConstraints = false
        legendView.accessibilityIdentifier = "legendView"
        legendView.isHidden = false


        let legendItems = [
            ("Low Risk", UIColor.green),
            ("Medium Risk", UIColor.orange),
            ("High Risk", UIColor.red)
        ]

        for (text, color) in legendItems {
            let colorBox = UIView()
            colorBox.backgroundColor = color.withAlphaComponent(0.8)
            colorBox.layer.cornerRadius = 4
            colorBox.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }

            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = UIColor(named: "MainColor")

            let itemStack = UIStackView(arrangedSubviews: [colorBox, label])
            itemStack.axis = .horizontal
            itemStack.spacing = 6
            legendView.addArrangedSubview(itemStack)
        }

        addSubview(legendView)

        legendView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    private func setUpWeatherContainer() {
        containerView.addSubview(weatherContainer)
        weatherContainer.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.9)
        weatherContainer.layer.cornerRadius = 15
        weatherContainer.clipsToBounds = true
        containerView.addSubview(weatherContainer)
        weatherContainer.isHidden = true
        weatherContainer.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(16)
        }

        weatherImageView.contentMode = .scaleAspectFit
        weatherContainer.addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(weatherContainer.snp.top).offset(20)
            make.centerX.equalTo(weatherContainer.snp.centerX)
            make.width.height.equalTo(100)
        }

        weatherDescriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        weatherDescriptionLabel.textColor = UIColor(named: "MainColor")
        weatherDescriptionLabel.textAlignment = .center
        weatherContainer.addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(10)
            make.centerX.equalTo(weatherContainer.snp.centerX)
        }

        temperatureLabel.font = .systemFont(ofSize: 24, weight: .bold)
        temperatureLabel.textColor = UIColor(named: "MainColor")
        weatherContainer.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(weatherContainer.snp.centerX)
        }

        humidityLabel.font = .systemFont(ofSize: 16, weight: .regular)
        humidityLabel.textColor = UIColor(named: "MainColor")
        weatherContainer.addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
            make.centerX.equalTo(weatherContainer.snp.centerX)
            make.bottom.lessThanOrEqualTo(weatherContainer.snp.bottom).offset(-20)
        }
    }

    @objc private func switchSection(_ sender: UISegmentedControl) {

        mapView.isHidden = true
        weatherContainer.isHidden = true
        subviews.forEach { if $0.accessibilityIdentifier == "legendView" { $0.isHidden = true } }

        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            subviews.forEach { if $0.accessibilityIdentifier == "legendView" { $0.isHidden = false } }
        case 1:
            weatherContainer.isHidden = false
        default: break
        }
    }

    func updateWeatherImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            weatherImageView.image = nil
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.weatherImageView.image = image
                }
            } else {
                print("Failed to load weather image: \(error?.localizedDescription ?? "No error")")
            }
        }.resume()
    }

    private func addLegend(to mapView: MKMapView) {
        let legend = UIStackView()
        legend.axis = .vertical
        legend.spacing = 8
        legend.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        legend.layer.cornerRadius = 12
        legend.layer.borderWidth = 1
        legend.layer.borderColor = UIColor.white.cgColor
        legend.isLayoutMarginsRelativeArrangement = true
        legend.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        let title = UILabel()
        title.text = "Flood Risk"
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 16)
        legend.addArrangedSubview(title)

        let risks = [
            ("High", UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)),
            ("Medium", UIColor.orange),
            ("Low", UIColor(red: 0.1, green: 0.8, blue: 0.1, alpha: 1.0))
        ]

        for (text, color) in risks {
            let row = UIStackView()
            row.spacing = 10

            let dot = UIView()
            dot.backgroundColor = color
            dot.layer.cornerRadius = 8
            dot.snp.makeConstraints { $0.width.height.equalTo(16) }

            let label = UILabel()
            label.text = text
            label.textColor = .white
            label.font = .systemFont(ofSize: 14)

            row.addArrangedSubview(dot)
            row.addArrangedSubview(label)
            legend.addArrangedSubview(row)
        }

        addSubview(legend)
        legend.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            legend.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -150),
            legend.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
