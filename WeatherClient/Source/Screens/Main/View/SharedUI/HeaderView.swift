//
//  HeaderView.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import UIKit

class HeaderView: UIView {
    private let titleLabel = UILabel()
    private let temperatureLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(temperatureLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        // Настройка titleLabel
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
        ])
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // Настройка temperatureLabel
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        ])
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 18)
        temperatureLabel.textAlignment = .center
    }

    func configure(cityName: String, temperature: String) {
        titleLabel.text = cityName
        temperatureLabel.text = "\(temperature)°"
    }
}

