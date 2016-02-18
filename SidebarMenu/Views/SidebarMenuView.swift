//
//  SidebarMenuView.swift
//  SidebarMenu
//
//  Created by Piotr Sochalewski on 20.01.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import UIKit

class SidebarMenuView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    
    var visible: Bool {
        return CGRectGetMidX(view.frame) >= 0.0
    }
    
    var view: UIView!
    
    init(width: CGFloat) {
        super.init(frame: CGRect(x: -width, y: 0.0, width: width, height: CGRectGetHeight(UIScreen.mainScreen().bounds)))
        view = NSBundle.mainBundle().loadNibNamed(String(self.dynamicType), owner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        tableView.separatorStyle = .None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(duration duration: CFTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: CGRectGetHeight(UIScreen.mainScreen().bounds))
        }
    }
    
    func dismiss(duration duration: CFTimeInterval, finished: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration,
            animations: {
                self.frame = CGRect(x: -self.frame.width, y: 0.0, width: self.frame.width, height: CGRectGetHeight(UIScreen.mainScreen().bounds))
            },
            completion: finished
        )
    }
    
}