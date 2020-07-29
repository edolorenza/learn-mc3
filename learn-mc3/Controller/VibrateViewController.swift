//
//  VibrateViewController.swift
//  learn-mc3
//
//  Created by Edo Lorenza on 29/07/20.
//  Copyright © 2020 Edo Lorenza. All rights reserved.
//

import UIKit
import AVFoundation

class VibrateViewController: UIViewController {
    
    let notification = UINotificationFeedbackGenerator()
    override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view.
      }
    @IBAction func btnSuccess(_ sender: UIButton) {
        notification.notificationOccurred(.success)
    }
    @IBAction func btnWarning(_ sender: UIButton) {
         notification.notificationOccurred(.warning)
    }
    @IBAction func btnError(_ sender: UIButton) {
        notification.notificationOccurred(.error)
    }
    @IBAction func btnLight(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    @IBAction func btnMedium(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    @IBAction func btnHeavy(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    @IBAction func btnVibrate(_ sender: UIButton) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}
