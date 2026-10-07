//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 07/10/2026.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
