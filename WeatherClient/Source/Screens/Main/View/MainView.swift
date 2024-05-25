//
//  MainView.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import UIKit

class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    private var collectionView: UICollectionView!
    private var headerView: HeaderView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupHeaderView()
        setupCollectionView()
    }
    
    private func setupHeaderView() {
        headerView = HeaderView(frame: .zero)
        headerView.backgroundColor = UIColor(red: 0.67, green: 0.84, blue: 0.90, alpha: 1.0)
        headerView.configure(with: "Graz")
        addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.HEADER_HEIGHT)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red: 0.67, green: 0.84, blue: 0.90, alpha: 1.0)
        addSubview(collectionView)
        
        // Register custom cell classes
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdentifier)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        
        // Configure layout constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    
    func setupWeather(text: String) {
    }
}

// MARK: - Constant
private enum Constant {
    
    static let HEADER_HEIGHT: CGFloat = 140.0
}
