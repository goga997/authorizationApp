//
//  AlertOk.swift
//  AuthorizationApp
//
//  Created by Grigore on 12.04.2023.
//

import UIKit

extension UIViewController {
    
    func alertOk(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}
