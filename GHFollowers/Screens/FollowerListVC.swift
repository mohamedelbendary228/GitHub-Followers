//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 21/08/2026.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           navigationController?.setNavigationBarHidden(false, animated: true)
           
//           let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
//           navigationItem.rightBarButtonItem = addButton
       }
    

    

}
