//
//  MainView.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import UIKit

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(red: 0.67, green: 0.84, blue: 0.90, alpha: 1.0) // Lighter blue color
        label.textColor = .white
        label.font = .systemFont(ofSize: 54.0)
        label.textAlignment = .center
    }
    
    func setupLayout() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.labelSideOffset).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.labelSideOffset).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: Constant.labelSideOffset).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.labelSideOffset).isActive = true
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    
    func setupWeather(text: String) {
        label.text = text
    }
}

// MARK: - Constant
private enum Constant {
    
    static let labelSideOffset: CGFloat = 30.0
}
