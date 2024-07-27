//
//  MainViewController.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 27.07.2024.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!

    private var configurator: MainConfiguratorProtocol = MainConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
}

extension MainViewController: MainViewProtocol {

}
