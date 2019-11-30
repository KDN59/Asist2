//
//  KalkanSevices.swift
//  KalkanAsist2
//
//  Created by KDN59 on 27.08.2019.
//  Copyright © 2019 KDN59. All rights reserved.
//

import Foundation
import AVFoundation

func KalkanServer(url_cmd: String, msg: String, result: @escaping (_ state: Bool?) -> Void) {
    let url = URL(string: url_cmd + "/Kalkan/KalkanServer.php?msg=" + msg)
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            return
        }
        if let data = data,
            let dataStr = String(data: data, encoding: String.Encoding.utf8) {
            if dataStr == "false" || dataStr == "0" {
                result(false)
            } else if dataStr == "true" || dataStr == "1" || dataStr == "MacMini" || dataStr == "RPi2" {
                result(true)
            } else {
                result(nil)
            }
        }
    }
    task.resume()
}

func ir_sender(urlStr: String, action: String) {
    AudioServicesPlayAlertSound(SystemSoundID(1057))
    MySound(string: "")
    var url = URL(string: urlStr)
    url = url?.appendingPathComponent(action)
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            return
        }
    }
    task.resume()
}

func restartModem(urlStr: String) {
    let url = URL(string: (urlStr + "/Kalkan/restartModem.php"))
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            return
        }
    }
    task.resume()
}

func getEnvironment(urlStr: String, result: @escaping (_ data: String?) -> Void) {
    let url = URL(string: (urlStr + "/env/getSens.php?req=last"))
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            result(nil)
            return
        }
        if let data = data,
            var dataStr = String(data: data, encoding: String.Encoding.utf8) {
            dataStr = String(dataStr.dropLast(1)) // remove "\n"
            result(dataStr)
        }
    }
    task.resume()
}
