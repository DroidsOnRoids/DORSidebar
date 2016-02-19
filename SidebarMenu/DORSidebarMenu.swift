//
//  DORSidebarMenu.swift
//  SidebarMenu
//
//  Created by Piotr Sochalewski on 19.01.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

import UIKit

public struct MenuElement {

    var title: String
    var textColor: UIColor
    var backgroundColor: UIColor
    
}

enum SidebarMenuError: ErrorType {
    
    case DifferentNumberOfControllersAndMenuElements(controllersCount: Int, menuElementsCount: Int)
    
}

public class DORSidebarMenu: UIWindow {
    
    // MARK: - Private constants
    private var sidebarMenuView: DORSidebarMenuView
    
    // MARK: - Public variables
    public var animateDuration: CFTimeInterval = 0.2
    public var controllers: [UIViewController?]
    /// Menu elements is an array storing a tuple containg `title`, `textColor` and `backgroundColor`
    public var menuElements = [MenuElement]() {
        didSet {
            sidebarMenuView.tableView.reloadData()
        }
    }
    override public var backgroundColor: UIColor? {
        set {
            sidebarMenuView.view.backgroundColor = newValue
        }
        get {
            return sidebarMenuView.view.backgroundColor
        }
    }
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
    
    private init(width: CGFloat, controllers: [UIViewController?]) {
        sidebarMenuView = DORSidebarMenuView(width: width)
        self.controllers = controllers

        super.init(frame: UIScreen.mainScreen().bounds)
        
        let viewController = UIViewController()
        frame = viewController.view.frame
        
        viewController.view.addSubview(sidebarMenuView)
        
        overlay = UIView(frame: CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: CGRectGetHeight(UIScreen.mainScreen().bounds)))
        
        sidebarMenuView.tableView.delegate = self
        sidebarMenuView.tableView.dataSource = self
        
        sidebarMenuView.dismissButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        rootViewController = viewController
        windowLevel = UIWindowLevelAlert
    }
    
    private func validateCounts<T, U>(a: [T], _ b: [U]) throws {
        if a.count != b.count {
            throw SidebarMenuError.DifferentNumberOfControllersAndMenuElements(controllersCount: a.count, menuElementsCount: b.count)
        }
    }
    
    /**
     Creates a SidebarMenu window. Sets each `menuElement` with black for text color and white for background color.
     - parameter controllers: The controllers that should be available from sidebar menu.
     - parameter menuElements: The array of strings with titles for rows in sidebar menu.
     */
    public convenience init(width: CGFloat, controllers: [UIViewController?], menuElements: [String]) throws {
        self.init(width: width, controllers: controllers)
        
        try validateCounts(controllers, menuElements)
        
        for title in menuElements {
            self.menuElements.append(MenuElement(title: title, textColor: .blackColor(), backgroundColor: .whiteColor()))
        }
    }
    
    /**
     Creates a SidebarMenu window.
     - parameter controllers: The controllers that should be available from sidebar menu.
     - parameter menuElements: The array of tuples with (title, text color, background color) for rows in sidebar menu.
     */
    public convenience init(width: CGFloat, controllers: [UIViewController?], menuElements: [MenuElement]) throws {
        self.init(width: width, controllers: controllers)
        
        try validateCounts(controllers, menuElements)
        
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
extension DORSidebarMenu: UITableViewDelegate {

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuElements.count
    }
    
}

// MARK: - UITableViewDataSource
extension DORSidebarMenu: UITableViewDataSource {

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
        
        if let controller = controllers[indexPath.row] where currentNavigationController?.viewControllers.last!.dynamicType != controller.dynamicType {
            currentNavigationController?.viewControllers = [controller]
        }
        dismiss()

    }
    
}