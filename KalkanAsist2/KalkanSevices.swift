//
//  KalkanSevices.swift
//  KalkanAsist2
//
//  Created by KDN59 on 27.08.2019.
//  Copyright © 2019 KDN59. All rights reserved.
//

import Foundation
import AVFoundation

func wemoSwitch(urlStr: String, action: String, result: @escaping (_ state: Bool?) -> Void) {
    let url = URL(string: (urlStr + "/upnp/control/basicevent1"))
    var cmd = ""
    switch action {
    case "GetState":
        cmd = "GetBinaryState"
    case "GetSignalStrength":
        cmd = "GetSignalStrength"
    case "GetName":
        cmd = "GetFriendlyName"
    case "SetStateOff", "SetStateOn":
        cmd = "SetBinaryState"
    default:
        result(nil)
        return
    }
    let session = URLSession.shared
    let request = NSMutableURLRequest(url: url!)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    // make header
    request.addValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
    request.addValue("\"urn:Belkin:service:basicevent:1#\(cmd)\"", forHTTPHeaderField: "SOAPACTION")
    
    // Determine body to send
    var parameterValueString = ""
    switch action {
    case "SetStateOn", "GetState": parameterValueString = "1"
    case "SetStateOff", "GetSignalStrength": parameterValueString = "0"
    default: parameterValueString = "None"
    }
    let parameterKey = cmd.replacingOccurrences(of: "Get", with: "").replacingOccurrences(of: "Set", with: "")
    let request_body = "<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:\(cmd) xmlns:u=\"urn:Belkin:service:basicevent:1\"><\(parameterKey)>\(parameterValueString)</\(parameterKey)></u:\(cmd)></s:Body></s:Envelope>"
    request.httpBody = request_body.data(using: String.Encoding.utf8)
    
    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        if let error = error {
            print ("qqq", "\(error)")
            result(nil)
        }
        if let data = data {
            let dataStr = String(data: data, encoding: String.Encoding.utf8) ?? "Error"
            if dataStr.contains("<\(parameterKey)>0") {
                result(false)
            } else if dataStr.contains("<\(parameterKey)>1") || dataStr.contains("<\(parameterKey)>8") {
                result(true)
            }
        }
    })
    task.resume()
}

func lightHue(urlStr: String, lamp_id: Int, action: String, result: @escaping (_ state: Bool?) -> Void) {
    // define url
    var url = URL(string: (urlStr + "/api/lDsSkeCR4uOVc1eKINVdVeEybe5gV1c9XoVlozKv/lights"))
    if action == "GetState" { // getState
        url = url?.appendingPathComponent("\(String(lamp_id))")
    } else {
        url = url?.appendingPathComponent("\(String(lamp_id))/state") // setState
    }
    let session = URLSession.shared
    let request = NSMutableURLRequest(url: url!)
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    if action == "GetState" { // getState
        request.httpMethod = "GET"
    } else { // setState
        request.httpMethod = "PUT"
        var params:[String: AnyObject] = [:]
        if action == "SetStateOn" { // setLightsOn
            params = ["on" : true as AnyObject]
        } else if action == "SetStateOff" { // setLightsOff
            params = ["on" : false as AnyObject]
        }
        request.httpBody =  try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
    }
    let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
        if let error = error {
            print ("\(error)")
            result(nil)
        }
        if let data = data {
            let dataStr = String(data: data, encoding: String.Encoding.utf8) ?? "Error"
            if action == "GetState" {
                if dataStr.contains("{\"state\":{\"on\":false") {
                    result(false)
                } else if dataStr.contains("{\"state\":{\"on\":true") {
                    result(true)
                }
            } else if action == "SetStateOn" || action == "SetStateOff" {
                if dataStr.contains("true") {
                    result(true)
                } else if dataStr.contains("false") {
                    result(false)
                }
            }
        }
    })
    task.resume()
}

func lightPiHall(urlStr: String, action: String, result: @escaping (_ state: Bool?) -> Void) {
    let url = URL(string: (urlStr + "/Assist/hallLight.php?req=" + action))
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            result(nil)
            return
        }
        if let data = data,
            let dataStr = String(data: data, encoding: String.Encoding.utf8) {
            if dataStr.contains("pin27:1") {
                result(true)
            } else if dataStr.contains("pin27:0") {
                result(false)
            }
        }
    }
    task.resume()
}

func IRServer(urlStr: String, action: String, result: @escaping (_ state: Bool?) -> Void) {
    // Determine body to send
    var parameterValueString = ""
    switch action {
        case "GetState": parameterValueString = "Status"
        case "SetStateOn": parameterValueString = "Sec_on"
        case "SetStateOff": parameterValueString = "Sec_off"
    default:
        parameterValueString = ""
    }

    var url = URL(string: urlStr)
    url = url?.appendingPathComponent(parameterValueString)
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            result(nil)
            return
        }
        if let data = data,
            let dataStr = String(data: data, encoding: String.Encoding.utf8) {
            if dataStr == "0" {
                result(false)
            } else if dataStr == "1" {
                result(true)
            }
        }
    }
    task.resume()
}

func ir_sender(urlStr: String, action: String) {
    AudioServicesPlayAlertSound(SystemSoundID(1057))
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
    let url = URL(string: (urlStr + "/Assist/restartModem.php"))
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

func statusLogFile(urlStr: String, result: @escaping (_ state: Bool?) -> Void) {
    let url = URL(string: (urlStr + "?msg=status"))
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
        guard error == nil else {
            print(error!)
            result(nil)
            return
        }
        if let data = data,
            var dataStr = String(data: data, encoding: String.Encoding.utf8) {
            dataStr = String(dataStr.dropLast(1)) // remove "\n"
            if dataStr == "False" {
                result(false)
            } else if dataStr == "True" {
                result(true)
            }
        }
    }
    task.resume()
}
