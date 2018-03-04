//
//  ViewController.swift
//  testingTabBarView
//
//  Created by Nick on 02/03/18.
//  Copyright © 2018 Nick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let new = Circle3DView()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        longPressGesture.minimumPressDuration = 0.3
        button.addGestureRecognizer(longPressGesture)
        new.delegate = self;
    }
    
    @objc func longPressAction(gesture : UILongPressGestureRecognizer){
        
        switch gesture.state {
        case .began :
            new.show(in: view)
        case .changed:
            new.panGestureForCircle(pan: gesture)
        case .ended:
            new.panGestureForCircle(pan: gesture)
            new.dismiss()
        case .cancelled,
             .possible,
             .failed: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : Circle3DViewDelegate{
    
    func selectedValue(index: Int) {
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.lightGray
        navigationController?.pushViewController(viewController, animated: true)
    }
}

