//
//  ViewController.swift
//  learn-mc3
//
//  Created by Edo Lorenza on 28/07/20.
//  Copyright © 2020 Edo Lorenza. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var player: AVAudioPlayer!
//    let notification = UINotificationFeedbackGenerator()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MPVolumeView.setVolume(0.1)
    }

    
    @IBAction func btnPress(_ sender: UIButton) {
//        notification.notificationOccurred(.success)
        MPVolumeView.setVolume(1.0)
//        hapticsHeavy()
        vibrate()
        playSound()
    }
    
    func hapticsHeavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
              generator.impactOccurred()
    }
    func vibrate() {
         AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    func playSound() {
       //silent mode override
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
        
           let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")
           player = try! AVAudioPlayer(contentsOf: url!)
           player.play()
                   
    }

}

extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}

