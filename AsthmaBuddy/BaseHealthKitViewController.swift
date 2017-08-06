//
//  HealthKitViewController.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 7/18/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import Foundation

// Definition:
extension Notification.Name {
    static let healthKitReady = Notification.Name("com.igorware.healthKitReadyKey")
}

@objc protocol BaseHealthKitViewControllerProtocol {
    func healthKitReady()
}
