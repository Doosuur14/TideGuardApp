//
//  SplashView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.04.2025.
//

import UIKit
import SnapKit

class SplashView: UIView {

    private lazy var floodedHouseImageView: UIImageView = UIImageView()
    private lazy var waterLayer: UIView = UIView()
    private lazy var waterWaveLayer: CAGradientLayer = CAGradientLayer()
    private var gradientLayer: CAGradientLayer!
    var onAnimationComplete: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupGradientBackground()
        setupFloodedHouse()
        setupRaindrops()
    }

    private func setupGradientBackground() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
//            UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1).cgColor,
//            UIColor(red: 47/255, green: 79/255, blue: 79/255, alpha: 1).cgColor
            UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1).cgColor,
            UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupFloodedHouse() {
        addSubview(floodedHouseImageView)
        floodedHouseImageView.image = UIImage(named: "floodedhouse")
        floodedHouseImageView.contentMode = .scaleAspectFill
        floodedHouseImageView.clipsToBounds = true
        floodedHouseImageView.layer.contentsGravity = .bottom
        floodedHouseImageView.layer.shadowColor = UIColor.black.cgColor
        floodedHouseImageView.layer.shadowOpacity = 0.3
        floodedHouseImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        floodedHouseImageView.layer.shadowRadius = 5
        floodedHouseImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(self.bounds.height * 0.45)
        }
    }

    private func setupRaindrops() {
        for _ in 0..<15 {
            let raindrop = UIView()
            raindrop.backgroundColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 0.5)
            raindrop.frame = CGRect(x: CGFloat.random(in: 0..<bounds.width), y: -20, width: 2, height: 10)
            raindrop.layer.cornerRadius = 1
            addSubview(raindrop)

            let fallAnimation = CABasicAnimation(keyPath: "position.y")
            fallAnimation.fromValue = -20
            fallAnimation.toValue = bounds.height + 20
            fallAnimation.duration = Double.random(in: 1.5...3.0)
            fallAnimation.repeatCount = .infinity
            fallAnimation.beginTime = CACurrentMediaTime() + Double.random(in: 0...1.0)
            raindrop.layer.add(fallAnimation, forKey: "fall")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func startAnimation() {
        animateHouseFloating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.onAnimationComplete?()
        }
    }

    private func animateHouseFloating() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.floodedHouseImageView.transform = CGAffineTransform(translationX: 0, y: -10)
        })
        let tiltAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        tiltAnimation.fromValue = -0.05
        tiltAnimation.toValue = 0.05
        tiltAnimation.duration = 1.5
        tiltAnimation.repeatCount = .infinity
        tiltAnimation.autoreverses = true
        floodedHouseImageView.layer.add(tiltAnimation, forKey: "tilt")
    }
}
