//
//  CustomViewController.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 31.05.2021.
//

import UIKit
class CustomViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showViewController(storyboardName: String = "Main", showingViewController: CustomViewController, navigationController: Bool, modalPresentationStyle: UIModalPresentationStyle = .automatic) {
            
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let showingViewController = storyboard.instantiateViewController(identifier: String(describing: type(of: showingViewController)))
        showingViewController.modalPresentationStyle = modalPresentationStyle
        
        if navigationController {
            self.navigationController?.pushViewController(showingViewController, animated: true)
        } else {
            present(showingViewController, animated: true)
        }
    }
    
}
