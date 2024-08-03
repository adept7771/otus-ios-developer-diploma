//
//  CommonComponents.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation
import UIKit

protocol CommonComponents: UIViewController {
}

extension CommonComponents {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func addAndActivateConstraints(to edges: [Edge], of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        for edge in edges {
            switch edge {
            case .top(let constant):
                constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: constant))
            case .bottom(let constant):
                constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant))
            case .leading(let constant):
                constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant))
            case .trailing(let constant):
                constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant))
            case .safeAreaTop(let constant):
                constraints.append(topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant))
            case .safeAreaBottom(let constant):
                constraints.append(bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant))
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
}

public enum Edge {
    case top(CGFloat)
    case bottom(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    case safeAreaTop(CGFloat)
    case safeAreaBottom(CGFloat)
}
