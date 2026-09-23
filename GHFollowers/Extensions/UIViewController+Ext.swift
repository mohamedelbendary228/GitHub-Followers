//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 23/08/2026.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    func presentSafariVC(with url: URL) {
           let safariVC = SFSafariViewController(url: url)
           present(safariVC, animated: true)
       }
    
}
