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
    
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        MPVolumeView.setVolume(0.1)
    }

    @IBAction func btnPress(_ sender: UIButton) {
        showAnimation()
        MPVolumeView.setVolume(0.0)
        vibrate()
        playSound()
    }
    
    func showAnimation() {
        let pulse = PulseAnimation(numberOfPulse: 3, radius: 200, postion: self.view.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = #colorLiteral(red: 0.05282949957, green: 0.5737867104, blue: 1, alpha: 1)
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
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
        }//sound file resource
           let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")
           player = try! AVAudioPlayer(contentsOf: url!)
           player.play()
    }

}

//volume slider extension
extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}
