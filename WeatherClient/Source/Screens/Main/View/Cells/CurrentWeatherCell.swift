//
//  CurrentWeatherCell.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    static let reuseIdentifier = "CurrentWeatherCell"
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(temperatureLabel)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with temperature: String) {
        temperatureLabel.text = temperature
    }
}
