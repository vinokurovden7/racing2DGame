//
//  UIView+Alert.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 07.06.2021.
//

import UIKit
extension UIViewController {

    func showAlert(titleAlert: String? = nil,
                   message: String? = nil,
                   style: UIAlertController.Style = .alert,
                   buttons: [(nameButton: String, buttonStyle: UIAlertAction.Style)],
                   completion: @escaping (String) -> Void ) {
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: style)

        for button in buttons {
            let alertAction = UIAlertAction(title: button.nameButton, style: button.buttonStyle) { action in
                guard let actionTitle = action.title else {return}
                completion(actionTitle)
            }
            alert.addAction(alertAction)
        }

        self.present(alert, animated: true)
    }

    func showAlertWithTextField(titleAlert: String? = nil,
                                message: String? = nil,
                                style: UIAlertController.Style = .alert,
                                completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: style)

        alert.addTextField { secondNameTextField in
            secondNameTextField.placeholder = "Player name"
            secondNameTextField.clearsOnBeginEditing = true
        }

        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let playerName = alert.textFields?[0].text else {return}
            completion(playerName)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }

}
