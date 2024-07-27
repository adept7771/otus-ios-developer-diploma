//
//  MainConfigurator.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 27.07.2024.
//

import Foundation

struct MainConfigurator: MainConfiguratorProtocol {
    func configure(with viewController: MainViewController) {
        
        let router = MainRouter(viewController: viewController)
        let presenter = MainPresenter(view: viewController, router: router)
        let interactor = MainInteractor(serverService: serverService,
                                       storageService: StorageService(),
                                       presenter: presenter)
        presenter.interactor = interactor

        viewController.presenter = presenter
    }

}
