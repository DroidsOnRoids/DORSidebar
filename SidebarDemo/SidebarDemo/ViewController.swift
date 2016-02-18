//
//  ViewController.swift
//  SidebarDemo
//
//  Created by Piotr Sochalewski on 18.02.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMenuButton()
    }

}

extension UIViewController {
    
    func showMenuButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu",
            style: .Plain,
            target: self,
            action: "showMenu")
    }
    
    func showMenu() {
        view.endEditing(true)
        (UIApplication.sharedApplication().delegate as! AppDelegate).sidebar?.show()
    }
    
}