//
//  TabBarController.swift
//  testingTabBarView
//
//  Created by Nick on 04/03/18.
//  Copyright © 2018 Nick. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let circleView = Circle3DView(frame: CGRect.zero, values: ["Navigation","Animation","Settings","Profile","More"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initilizeTabBar()
        addChildViewControllerToTabBar()
        setupMiddleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setupMiddleButton() {
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 5
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        view.addSubview(menuButton)
        menuButton.setImage(UIImage(named: "selected"), for: .normal)
        menuButton.backgroundColor = UIColor(red: 45/255, green: 62/255, blue: 79/255, alpha: 1.0)
        menuButton.layer.cornerRadius = 32

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        longPressGesture.minimumPressDuration = 0.3
        menuButton.addGestureRecognizer(longPressGesture)
        circleView.delegate = self;
        
        view.layoutIfNeeded()
    }
    
    
    @objc func longPressAction(gesture : UILongPressGestureRecognizer){
        
        switch gesture.state {
        case .began :
            circleView.show(in: view)
        case .changed:
            circleView.panGestureForCircle(pan: gesture)
        case .ended:
            circleView.panGestureForCircle(pan: gesture)
            circleView.dismiss()
        case .cancelled,
             .possible,
             .failed: break
        }
    }
    
    
    func initilizeTabBar() {
        
        let tabBarItem = UITabBarItem.appearance(whenContainedInInstancesOf: [TabBarController.self])
        var dictNormal = [NSAttributedStringKey : Any]()
        dictNormal[NSAttributedStringKey.foregroundColor] = UIColor.gray
        dictNormal[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 11)
        var dictSelected = [NSAttributedStringKey : Any]()
        dictSelected[NSAttributedStringKey.foregroundColor] = UIColor.darkGray
        dictSelected[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 11)
        tabBarItem.setTitleTextAttributes(dictNormal, for: .normal)
        tabBarItem.setTitleTextAttributes(dictSelected, for: .selected)
    }
    
    
    func addChildViewControllerToTabBar() {
        
        let HomeVC = UIViewController()
        setUpViewController(HomeVC, image: "home_normal", selectedImage: "home_highlight", title: "Home")
        
        let FishVC = UIViewController()
        setUpViewController(FishVC, image: "fish_normal", selectedImage: "fish_highlight", title: "Fishing")
        
        let middle = UIViewController()
        addChildViewController(middle)
        
        let MessageVC = UIViewController()
        setUpViewController(MessageVC, image: "message_normal", selectedImage: "message_highlight", title: "Message")
        
        let MineVC = UIViewController()
        setUpViewController(MineVC, image: "account_normal", selectedImage: "account_highlight", title: "Account")
        
    }
    

    func setUpViewController(_ Vc: UIViewController, image: String, selectedImage: String, title: String) {
        
        let nav = UINavigationController(rootViewController: Vc)
        nav.setNavigationBarHidden(true, animated: true)
        Vc.view.backgroundColor = randomColor()
        var myImage = UIImage(named: image)
        myImage = myImage?.withRenderingMode(.alwaysOriginal)
        Vc.tabBarItem.image = myImage
        var mySelectedImage = UIImage(named: selectedImage)
        mySelectedImage = mySelectedImage?.withRenderingMode(.alwaysOriginal)
        Vc.tabBarItem.selectedImage = mySelectedImage
        Vc.tabBarItem.title = title
        Vc.navigationItem.title = title
        addChildViewController(nav)
    }
    
    @objc func middleButtonPressed(){
        
    }
    
    func randomColor() -> UIColor {
        
        let r: CGFloat = CGFloat(arc4random_uniform(256))
        let g: CGFloat = CGFloat(arc4random_uniform(256))
        let b: CGFloat = CGFloat(arc4random_uniform(256))
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}

extension TabBarController : Circle3DViewDelegate{
    
    func selectedValue(index: Int) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = randomColor()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(viewController, animated: true)
        print("selected \(index)")
    }
}


