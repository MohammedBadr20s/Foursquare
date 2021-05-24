//
//  UITableView+Extension.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit


extension UITableView {
    func showStateView(show: Bool, state: State? = nil, msg: String? = nil) {
        if show {
            let stateView = StateView(frame: CGRect(x: 0, y: self.center.y, width: self.frame.width, height: self.frame.height))
            stateView.config(status: state ?? .loading, msg: msg)
            self.tableFooterView = stateView
        } else {
            self.tableFooterView = nil
        }
    }
}
