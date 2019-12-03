//
//  swayderAudioPlayer.swift
//  Ilya_Swayder
//
//  Created by ilya_admin on 11/08/2019.
//  Copyright © 2019 ilya_admin. All rights reserved.
//

import Foundation
import AVFoundation

class swayderAudioPlayer {
    private var audioPlayer:AVAudioPlayer!
    private var isAudioPaused:Bool = false
    private var isAudioPlaying:Bool = false
    private var audioFileUrl:URL?
    
    init () {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            
        }
    }
    
    func pauseAudio() {
        if isAudioPlaying == true {
            audioPlayer.pause()
            isAudioPaused = true
        }
    }
    
    func playAudio(fileName:String, fileExtension:String) {
        //let urlName = fileName + ".mp3"
        let url = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        //audioFileUrl = Bundle.main.url(forResource: <#T##String?#>, withExtension: <#T##String?#>)
      //  audioFileUrl = Bundle.main.ur//Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        audioFileUrl = URL.init(fileURLWithPath: url!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl! )
             audioPlayer.play()
             isAudioPlaying = true
             isAudioPaused = false
        } catch {
            print("shit")
        }
       
 
    }
    
    func unpauseAudio () {
        if isAudioPaused == true {
            audioPlayer.play()
            isAudioPaused = false
        }
    }
    
    func stopPlaying() {
        if isAudioPlaying == true {
            audioPlayer.stop()
            isAudioPlaying = false
        }
    }
    
    func audioLengthGe(fileName:String, fileExtension:String) -> Int {
        audioFileUrl = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        let avAudioPlayer = try? AVAudioPlayer (contentsOf:audioFileUrl!)
        let duration = Int(avAudioPlayer!.duration)
        return Int(duration%60)

    }
}
