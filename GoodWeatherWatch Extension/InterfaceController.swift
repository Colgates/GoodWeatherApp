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
        presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji) { (results) in
            guard let results = results else { return }
//            self.cityNameLabel.setText(results[0] as? String)
            
            WCSession.default.sendMessage(["message":results[0]], replyHandler: nil)
            
//            if WCSession.isSupported() {
//                do {
//                    try WCSession.default.updateApplicationContext(["cityName":results[0]])
//                } catch {
//                    print("Error sending data to phone")
//                }
//            }
        }
        
        
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            let string = applicationContext["temp"] as? String ?? ""
            self.temperatureLabel.setText(string + "°")
            self.cityNameLabel.setText(applicationContext["city"] as? String ?? "")
            self.conditionImage.setImage(UIImage(systemName: applicationContext["condition"] as? String ?? ""))
            self.conditionLabel.setText(applicationContext["description"] as? String ?? "")
            
            //need another background when temp below zero
            if let safeTemp = applicationContext["temp"] as? String {
                if safeTemp.contains("-") {
                    self.group.setBackgroundImageNamed("cloudsnow")
                } else {
                    self.group.setBackgroundImageNamed(applicationContext["image"] as? String ?? "")
                }
            }
        }
    }
}
