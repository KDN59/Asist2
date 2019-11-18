//
//  Common.swift
//  KalkanAsist2
//
//  Created by KDN59 on 27.08.2019.
//  Copyright © 2019 KDN59. All rights reserved.
//

import Foundation
import Speech
import LocalAuthentication
import AVFoundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation

public class SSID {
    class func fetchNetworkInfo() -> [NetworkInfo]? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            var networkInfos = [NetworkInfo]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo(interface: interfaceName,
                                              success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
        return nil
    }
}

public func getSSID() {
    // check SSID to define pr_local
    let status = CLLocationManager.authorizationStatus()
    if status == .authorizedWhenInUse {
        let wifi_ssid = currentNetworkInfos?.first?.ssid ?? ""
        if (wifi_ssid == "KDN Network" || wifi_ssid == "KDN Network 5") {
            pr_local = true
        } else  {
            pr_local = false
        }
    }
}

struct NetworkInfo {
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}

public func MySound( string: String) {
    let utterance = AVSpeechUtterance(string: string)
    utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
    utterance.volume = 1.0
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
    utterance.pitchMultiplier = 1.0
    utterance.preUtteranceDelay = 0.5
    synthesizer.speak(utterance)
}

public func startRecognising() {
    // form recognition task
    if recognitionTask != nil {
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    // form recognition request
    let inputNode = audioEngine.inputNode
    let format = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
        buffer, _ in
        recognitionRequest.append(buffer)
    }
    audioEngine.prepare()
    do {
        try audioEngine.start()
    } catch {
        print("Не удается стартaнуть движок")
        return
    }
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) {
        result, error in
        if let res = result {
            res_text = res.bestTranscription.formattedString
        } else if let error = error {
            inputNode.removeTap(onBus: 0)
            audioEngine.stop()
        }
        if error == nil {
            restartSpeechTimer()
        } else {
            inputNode.removeTap(onBus: 0)
        }
    }
    
    // set timer for limited silence time 1.5 sec
    func restartSpeechTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            recognitionRequest.endAudio()
            recognitionTask?.cancel()
            pr_voice_recog = true // res of recognition in res_text is ready
        })
    }
}

func end_suffix(value: String, word: String) -> String {
    let round_word = String(format: "%.0f", Float(value)!)
    if round_word.suffix(2) == "11" || round_word.suffix(2) == "12" || round_word.suffix(2) == "13" || round_word.suffix(2) == "14" {
        return word + "ов"
    } else if round_word.suffix(1) == "1" {
        return word
    } else if round_word.suffix(1) == "2" || round_word.suffix(1) == "3" || round_word.suffix(1) == "4" {
        return word + "а"
    } else {
        return word + "ов"
    }
}


