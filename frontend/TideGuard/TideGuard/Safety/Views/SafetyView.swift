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
    lazy var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Map","Weather", "Forecast"])

    lazy var containerView: UIView = UIView()
    lazy var mapView: MKMapView = MKMapView()

    lazy var forecastContainer: UIView = UIView()
    lazy var forecastScrollView: UIScrollView = UIScrollView()
    lazy var forecastContentView: UIView = UIView()

    lazy var weatherForecastHeaderLabel: UILabel = UILabel()
    lazy var floodForecastHeaderLabel: UILabel = UILabel()


    lazy var weeklyWeatherStackView: UIStackView = UIStackView()


    lazy var monthlyFloodStackView: UIStackView = UIStackView()


    lazy var weatherContainer: UIView = UIView()
    lazy var weatherImageView: UIImageView = UIImageView()
    lazy var weatherDescriptionLabel: UILabel = UILabel()
    lazy var temperatureLabel: UILabel = UILabel()
    lazy var humidityLabel: UILabel = UILabel()
    lazy var activityIndicator = UIActivityIndicatorView(style: .large)

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
        setUpWeatherContainer()
        setupForecastContainer()
        setupForecastContent()
        setupActivityIndicator()

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


    private func setUpWeatherContainer() {
        containerView.addSubview(weatherContainer)
        weatherContainer.backgroundColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(0.9)
        weatherContainer.layer.cornerRadius = 15
        weatherContainer.clipsToBounds = true
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

    private func setupForecastContainer() {
        containerView.addSubview(forecastContainer)
        forecastContainer.isHidden = true
        forecastContainer.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
    }

    private func  setupForecastContent() {
        forecastContainer.addSubview(forecastScrollView)

        forecastScrollView.showsVerticalScrollIndicator = false
        forecastScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        forecastScrollView.addSubview(forecastContentView)
        forecastContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(forecastScrollView)
        }


        forecastContentView.addSubview(weatherForecastHeaderLabel)
        weatherForecastHeaderLabel.text = "7-Day Forecast"
        weatherForecastHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        weatherForecastHeaderLabel.textColor = UIColor(named: "MainColor")
        weatherForecastHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(16)
        }


        forecastContentView.addSubview(weeklyWeatherStackView)
        weeklyWeatherStackView.axis = .horizontal
        weeklyWeatherStackView.distribution = .fillEqually
        weeklyWeatherStackView.spacing = 8
        weeklyWeatherStackView.snp.makeConstraints { make in
            make.top.equalTo(weatherForecastHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }


        let divider = UIView()
        divider.backgroundColor = UIColor.systemGray5
        forecastContentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(weeklyWeatherStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }


        forecastContentView.addSubview(floodForecastHeaderLabel)
        floodForecastHeaderLabel.text = "Monthly Flood Risk Forecast"
        floodForecastHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        floodForecastHeaderLabel.textColor = UIColor(named: "MainColor")
        floodForecastHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }


        forecastContentView.addSubview(monthlyFloodStackView)
        monthlyFloodStackView.axis = .vertical
        monthlyFloodStackView.spacing = 12
        monthlyFloodStackView.snp.makeConstraints { make in
            make.top.equalTo(floodForecastHeaderLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
        }
    }



    @objc private func switchSection(_ sender: UISegmentedControl) {

        mapView.isHidden = true
        weatherContainer.isHidden = true
        forecastContainer.isHidden = true

        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
        case 1:
            weatherContainer.isHidden = false
        case 2:
                forecastContainer.isHidden = false
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



    func updateWeeklyForecast(with data: [WeatherData.DailyForecast]) {
        weeklyWeatherStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for day in data {
            let card = makeDayWeatherCard(day: day)
            weeklyWeatherStackView.addArrangedSubview(card)
        }
    }


    private func makeDayWeatherCard(day: WeatherData.DailyForecast) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.systemGray6
        card.layer.cornerRadius = 12

        // Day name e.g "Mon"
        let dayLabel = UILabel()
        dayLabel.text = day.date ?? "-"
        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dayLabel.textAlignment = .center
        dayLabel.textColor = .secondaryLabel
        card.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }


        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        card.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(32)
        }

        if let iconUrl = day.icon, let url = URL(string: iconUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        iconImageView.image = image
                    }
                }
            }.resume()
        }

        let tempLabel = UILabel()
        let maxTemp = day.maxTemp ?? 0
        let minTemp = day.minTemp ?? 0
        tempLabel.text = "\(Int(maxTemp))°/\(Int(minTemp))°"
        tempLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        tempLabel.textAlignment = .center
        tempLabel.textColor = .label
        card.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }

        return card
    }

    func updateMonthlyFloodForecast(_ monthlyRisks: [Int]) {

        monthlyFloodStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        // Split into two rows of 6
        let firstHalf  = Array(zip(monthNames.prefix(6), monthlyRisks.prefix(6)))
        let secondHalf = Array(zip(monthNames.suffix(6), monthlyRisks.suffix(6)))

        for half in [firstHalf, secondHalf] {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8

            for (month, risk) in half {
                let cell = makeMonthRiskCell(month: month, risk: risk)
                rowStack.addArrangedSubview(cell)
            }
            monthlyFloodStackView.addArrangedSubview(rowStack)
        }
    }


    private func makeMonthRiskCell(month: String, risk: Int) -> UIView {
        let cell = UIView()
        cell.backgroundColor = UIColor.systemGray6
        cell.layer.cornerRadius = 12

        let monthLabel = UILabel()
        monthLabel.text = month
        monthLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        monthLabel.textAlignment = .center
        monthLabel.textColor = .secondaryLabel
        cell.addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }

        let riskLabel = UILabel()
        riskLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        riskLabel.textAlignment = .center

        let dot = UIView()
        dot.layer.cornerRadius = 8

        switch risk {
        case 2:
            dot.backgroundColor = .systemRed
            riskLabel.text = "High"
            riskLabel.textColor = .systemRed
        case 1:
            dot.backgroundColor = .systemOrange
            riskLabel.text = "Med"
            riskLabel.textColor = .systemOrange
        default:
            dot.backgroundColor = .systemGreen
            riskLabel.text = "Low"
            riskLabel.textColor = .systemGreen
        }

        cell.addSubview(dot)
        dot.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(16)
        }

        cell.addSubview(riskLabel)
        riskLabel.snp.makeConstraints { make in
            make.top.equalTo(dot.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }

        return cell
    }

    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func showLoadingSpinner() {
        activityIndicator.startAnimating()
        isUserInteractionEnabled = false
    }

    func hideLoadingSpinner() {
        activityIndicator.stopAnimating()
        isUserInteractionEnabled = true
    }
}
