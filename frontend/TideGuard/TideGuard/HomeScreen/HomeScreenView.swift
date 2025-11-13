//
//  HomeScreenView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 26.03.2025.
//

import UIKit

final class HomeScreenView: UIView {
    lazy var backgroundImage: UIImageView = UIImageView()
    let secondView = HomeScreenDesignView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFunctions()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpFunctions() {
        setUpBackgroundImage()
        setUpSecondView()
    }

    private func setUpBackgroundImage() {
        addSubview(backgroundImage)
        backgroundImage.image = UIImage(named: "tideguard")
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
    }

    private func  setUpSecondView() {
        addSubview(secondView)
        backgroundColor = .white
        secondView.backgroundColor = .white
        secondView.layer.cornerRadius = 10
        secondView.backgroundColor = .systemBackground
        secondView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(300)
        }
    }

}
