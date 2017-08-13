//
//  MainViewController.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 8/1/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import UIKit

//[ ] Insert nice looking sample data for "last week in Denver"


class MainViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var containerView: UIView!
    
    private lazy var profileViewController: ProfileViewController = {
        return self.instantiateViewController(withName: "ProfileViewController") as! ProfileViewController
    }()
    
    private lazy var insightsViewController: InsightsViewController = {
        return self.instantiateViewController(withName: "InsightsViewController") as! InsightsViewController
    }()
    
    func instantiateViewController(withName name:String) -> BaseHealthKitViewControllerProtocol {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: name) as! BaseHealthKitViewControllerProtocol
        NotificationCenter.default.addObserver(viewController, selector: #selector(BaseHealthKitViewControllerProtocol.healthKitReady), name: .healthKitReady, object: nil)
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController as! UIViewController)
        
        return viewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlSwitched(_ sender: Any) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: self.insightsViewController)
            add(asChildViewController: self.profileViewController)
        } else {
            remove(asChildViewController: self.profileViewController)
            add(asChildViewController: self.insightsViewController)
        }

    }
}

// manage child view controllers
extension MainViewController {
    fileprivate func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
}

