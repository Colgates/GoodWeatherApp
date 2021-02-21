//
//  InterfaceController.swift
//  GoodWeatherWatch Extension
//
//  Created by Evgenii Kolgin on 20.02.2021.
//

import WatchKit
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var group: WKInterfaceGroup!
    @IBOutlet weak var cityNameLabel: WKInterfaceLabel!
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var conditionImage: WKInterfaceImage!
    @IBOutlet weak var conditionLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        setupWatchConnectivity()
    }
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    
    
    @IBAction func updateButtonTapped() {
        sendDataToPhone()
    }
    
    func sendDataToPhone() {
        if WCSession.isSupported() {
print("send data to phone")
            do {
                try WCSession.default.updateApplicationContext(["data":"update"])
                WCSession.default.sendMessage(["data":"update1"], replyHandler: nil, errorHandler: nil)
            } catch {
                print("error")
            }
        }
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            
            self.temperatureLabel.setText(applicationContext["temp"] as? String ?? "")
            self.cityNameLabel.setText(applicationContext["city"] as? String ?? "")
            self.conditionImage.setImage(UIImage(systemName: applicationContext["condition"] as? String ?? ""))
            self.conditionLabel.setText(applicationContext["description"] as? String ?? "")
            self.group.setBackgroundImageNamed(applicationContext["condition"] as? String ?? "")
        }
    }
}

