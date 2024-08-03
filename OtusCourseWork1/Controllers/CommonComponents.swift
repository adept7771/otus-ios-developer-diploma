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

import UIKit

extension UIView {
    func addAndActivateConstraints(to edges: [Edge], of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        for edge in edges {
            switch edge {
            case .top(let constant, let relativeTo):
                constraints.append(topAnchor.constraint(equalTo: relativeTo ?? view.topAnchor, constant: constant))
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
            case .safeAreaLeading(let constant):
                constraints.append(leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant))
            case .safeAreaTrailing(let constant):
                constraints.append(trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constant))
            case .height(let constant):
                constraints.append(heightAnchor.constraint(equalToConstant: constant))
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
}

public enum Edge {
    case top(CGFloat, relativeTo: NSLayoutYAxisAnchor? = nil)
    case bottom(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    case safeAreaTop(CGFloat)
    case safeAreaBottom(CGFloat)
    case safeAreaLeading(CGFloat)
    case safeAreaTrailing(CGFloat)
    case height(CGFloat)
}

