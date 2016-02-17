//
//  SidebarMenuView.swift
//  Bitoad
//
//  Created by Piotr Sochalewski on 20.01.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import UIKit

public class SidebarMenuView: UIView {
    
    @IBOutlet private weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet public weak var tableView: UITableView!
    @IBOutlet public weak var dismissButton: UIButton!
    
    public var view: UIView!
    private var sidebarMenuWidth: CGFloat = 0.0
    public var visible: Bool {
        return CGRectGetMidX(view.frame) >= 0.0
    }
    
    public init(width: CGFloat) {
        super.init(frame: CGRect(x: -width, y: 0.0, width: width, height: CGRectGetHeight(UIScreen.mainScreen().bounds)))
        view = NSBundle.mainBundle().loadNibNamed(String(self.dynamicType), owner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        sidebarMenuWidth = width
        tableViewWidthConstraint.constant = width
        view.updateConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(duration duration: CFTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.frame = CGRect(x: 0.0, y: 0.0, width: self.sidebarMenuWidth, height: CGRectGetHeight(UIScreen.mainScreen().bounds))
        }
    }
    
    public func dismiss(duration duration: CFTimeInterval, finished: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration,
            animations: {
                self.frame = CGRect(x: -self.sidebarMenuWidth, y: 0.0, width: self.sidebarMenuWidth, height: CGRectGetHeight(UIScreen.mainScreen().bounds))
            },
            completion: finished
        )
    }
    
}