//
//  SoundManager.swift
//  FLIPPER
//
//  Created by SHUBHAM KUMAR on 29/05/21.
//

import Foundation
import AVFoundation

class SoundManager{
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect){
        
        var soundFilename = ""
        
        //         determine sound efect
        switch  effect {
        
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
            
        //            default:
        //                soundFilename = ""
        
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find filename \(soundFilename)")
            return
        }
        
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        }
        
        catch {
            print("Couldn't create audio player object for file \(soundFilename)")
        }
    }
}
