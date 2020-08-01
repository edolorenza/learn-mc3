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
    
    var timer: Timer!
    var device: AVCaptureDevice!
    var player: AVAudioPlayer!
    
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        MPVolumeView.setVolume(0.5)
    }

    @IBAction func btnPress(_ sender: UIButton) {
       guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
       self.device = device
        
        MPVolumeView.setVolume(1.0)
        showAnimation()
        vibrate()
        playSound()
        playTorch()
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
           try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        //headset override
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
           try AVAudioSession.sharedInstance().setActive(true)
       } catch {
           print(error)
       
        }//sound file resource
           let url = Bundle.main.url(forResource: "polisi", withExtension: "mp3")
           player = try! AVAudioPlayer(contentsOf: url!)
           player.play()
    }
    
     @objc
     private func playTorch(){
         if self.timer != nil {
             self.timer.invalidate()
             self.timer = nil
         }
         
         // MARK: Background Timer, still not working for Torch mode
         
         //        var bgTask = UIBackgroundTaskIdentifier(rawValue: 10)
         //        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
         //            UIApplication.shared.endBackgroundTask(bgTask)
         //        })
         
         self.timer = Timer()
         self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(playSampleFlash), userInfo: nil, repeats: true)
     }
     
     @objc
     private func playSampleFlash(){
         guard self.device.hasTorch else { return }
         
         do {
             try device.lockForConfiguration()
             
             if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                 device.torchMode = AVCaptureDevice.TorchMode.off
             } else {
                 do {
                     try device.setTorchModeOn(level: 1.0)
                 } catch {
                     print(error)
                 }
             }
             device.unlockForConfiguration()
         } catch {
             print(error)
         }
     }
    
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y + translation.y
      )

      // 3
      gesture.setTranslation(.zero, in: view)
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

