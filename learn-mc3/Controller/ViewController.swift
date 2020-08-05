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
    
    
    
    @IBOutlet weak var safeLbl: UIButton!
    @IBOutlet weak var shieldBtn: UIButton!
    //    var gradientView = GradientView()
    
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
        setGradientBackground()
        showAnimation()
        vibrate()
        shieldBtn.setImage(UIImage(named: "button_active"), for: .normal)
        playSound()
        playTorch()
        safeLbl.setTitle("I'm safe now", for: .normal)
    }
    
    func showAnimation() {
        let pulse = PulseAnimation(numberOfPulse: 100, radius: 400, postion: self.view.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
        
        let pulse1 = PulseAnimation(numberOfPulse: 100, radius: 400, postion: self.view.center)
          pulse1.animationDuration = 1.2
          pulse1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
          self.view.layer.insertSublayer(pulse1, below: self.view.layer)

        
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
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 224.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0).cgColor
        //merah E02020
        let colorBottom = UIColor(red: 10.0/255.0, green: 99.0/255.0, blue: 172.0/255.0, alpha: 1.0).cgColor
        //biru 0A63AC

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
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

