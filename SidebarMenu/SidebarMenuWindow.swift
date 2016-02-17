//
//  SidebarMenuWindow.swift
//  Bitoad
//
//  Created by Piotr Sochalewski on 19.01.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import UIKit

public typealias MenuElement = (title: String, textColor: UIColor, backgroundColor: UIColor)

public class SidebarMenu: UIWindow {
    
    // MARK: - Private constants
    private let sidebarMenuView = SidebarMenuView(width: 240)
    
    // MARK: - Public variables
    public var animateDuration: CFTimeInterval = 0.2
    public var sidebarMenuWidth: CGFloat = 260.0
    public var controllers: [UIViewController?]?
    /// Menu elements is an array storing a tuple containg `title`, `textColor` and `backgroundColor`
    public var menuElements = [MenuElement]() {
        didSet {
            sidebarMenuView.tableView.reloadData()
        }
    }
    public var currentVisibleViewController: UIViewController?
    
    public var overlayVisible = false {
        didSet {
            if overlayVisible != oldValue {
                if overlayVisible {
                    rootViewController?.view.addSubview(overlay)
                    rootViewController?.view.bringSubviewToFront(sidebarMenuView)
                } else {
                    overlay.removeFromSuperview()
                }
            }
        }
    }
    public var overlayColor = UIColor.clearColor() {
        didSet {
            overlay.backgroundColor = overlayColor
        }
    }
    public var overlayAlpha: CGFloat = 0.0 {
        didSet {
            overlay.alpha = overlayAlpha
        }
    }
    
    // MARK: - Private variables
    private var overlay: UIView!
    
    private var currentNavigationController: UINavigationController? {
        return UIApplication.sharedApplication().windows.first?.rootViewController as? UINavigationController
    }
    
    // MARK: - Initializers
    
    private init(controllers: [UIViewController?]?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.controllers = controllers
        
        let viewController = UIViewController()
        frame = viewController.view.frame
        
        viewController.view.addSubview(sidebarMenuView)
        
        overlay = UIView(frame: CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: CGRectGetHeight(UIScreen.mainScreen().bounds)))
        
        sidebarMenuView.tableView.delegate = self
        sidebarMenuView.tableView.dataSource = self
        
        sidebarMenuView.dismissButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        rootViewController = viewController
        windowLevel = UIWindowLevelAlert
        
        currentNavigationController?.pushViewController((self.controllers?.first!)!, animated: false)
    }
    
    /**
     Creates a SidebarMenu window. Sets each `menuElement` with black for text color and white for background color.
     - parameter controllers: The controllers that should be available from sidebar menu.
     - parameter menuElements: The array of strings with titles for rows in sidebar menu.
     */
    public convenience init(controllers: [UIViewController?]?, menuElements: [String]) {
        self.init(controllers: controllers)
        for title in menuElements {
            self.menuElements.append(MenuElement(title, .blackColor(), .whiteColor()))
        }
    }
    
    /**
     Creates a SidebarMenu window.
     - parameter controllers: The controllers that should be available from sidebar menu.
     - parameter menuElements: The array of tuples with (title, text color, background color) for rows in sidebar menu.
     */
    public convenience init(controllers: [UIViewController?]?, menuElements: [MenuElement]) {
        self.init(controllers: controllers)
        self.menuElements = menuElements
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        show(duration: animateDuration)
    }
    
    public func show(duration duration: CFTimeInterval) {
        makeKeyAndVisible()
        sidebarMenuView.show(duration: duration)
    }
    
    public func dismiss() {
        dismiss(duration: animateDuration)
    }
    
    public func dismiss(duration duration: CFTimeInterval) {
        if sidebarMenuView.visible {
            sidebarMenuView.dismiss(duration: duration) { _ in
                self.hidden = true
                UIApplication.sharedApplication().windows.first?.makeKeyAndVisible()
            }
        }
    }
    
    // MARK: - Touches
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        dismiss()
    }
    
}

// MARK: - UITableViewDelegate
extension SidebarMenu: UITableViewDelegate {

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuElements.count
    }
    
}

// MARK: - UITableViewDataSource
extension SidebarMenu: UITableViewDataSource {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = menuElements[indexPath.row].title
        cell?.textLabel?.textColor = menuElements[indexPath.row].textColor
        cell?.backgroundColor = menuElements[indexPath.row].backgroundColor
        cell?.selectionStyle = .Gray
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let roomsViewController = currentNavigationController?.viewControllers.last as? RoomsViewController {
            roomsViewController.roomTableView.safelyDiscardAddingRow()
        }
        
        if let controller = controllers?[indexPath.row] where currentNavigationController?.viewControllers.last!.dynamicType != controller.dynamicType {
            currentNavigationController?.viewControllers = [controller]
        }
        dismiss()

    }
    
}