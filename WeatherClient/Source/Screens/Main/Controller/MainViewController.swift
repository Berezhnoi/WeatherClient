//
//  MainViewController.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var model: MainModelProtocol!
    var contentView: MainViewProtocol!
    
    override func loadView() {
        let mainView = MainView(frame: .zero)
        mainView.delegate = self
        contentView = mainView
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        model.loadData()
    }
    
    private func setupInitialState() {
        let mainModel = MainModel(delegate: self)
        model = mainModel
    }
}

// MARK: - MainViewDelegate
extension MainViewController: MainViewDelegate {
    
    func cityDidTap() {
        model.loadData()
    }
}

// MARK: - MainModelDelegate
extension MainViewController: MainModelDelegate {
    
    func dataDidLoad(with data: CDWeatherInfo) {
        let dataToShow =  "\(data.temperature)"
        contentView.setupWeather(text: dataToShow)
    }
}