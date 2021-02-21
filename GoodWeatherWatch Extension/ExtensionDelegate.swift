//
//  ExtensionDelegate.swift
//  GoodWeatherWatch Extension
//
//  Created by Evgenii Kolgin on 20.02.2021.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
        setupWatchConnectivity()
    }
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
}

extension ExtensionDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC session failed: \(error.localizedDescription)")
            return
        }
        print("WC session activated \(activationState.rawValue)")
    }
}


