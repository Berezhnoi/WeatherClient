//
//  ForecastCell.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import UIKit

class ForecastCell: UITableViewCell {
    static let reuseIdentifier = "ForecastCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let temperatureMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let temperatureMaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let weatherIconImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(temperatureMinLabel)
        stackView.addArrangedSubview(temperatureMaxLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints for the icon's size
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func configure(title: String, tempMin: String, tempMax: String, weatherCondition: String?) {
        titleLabel.text = title
        temperatureMinLabel.text = tempMin
        temperatureMaxLabel.text = tempMax
        if let weatherCondition = weatherCondition, let iconImage = UIImage(named: weatherCondition) {
            weatherIconImageView.image = iconImage
        }
    }
    
    func applyBorderRadius(top: Bool, bottom: Bool) {
        var corners: UIRectCorner = []
        var cornerRadii: CGSize = .zero
        
        if top {
            corners.insert([.topLeft, .topRight])
            cornerRadii = CGSize(width: 12, height: 12)
        }
        
        if bottom {
            corners.insert([.bottomLeft, .bottomRight])
            cornerRadii = CGSize(width: 12, height: 12)
        }
        
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
