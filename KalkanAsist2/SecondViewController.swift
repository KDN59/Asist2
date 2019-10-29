//
//  SecondViewController.swift
//  KalkanAsist2
//
//  Created by KDN59 on 26.08.2019.
//  Copyright © 2019 KDN59. All rights reserved.
//

import UIKit
import Speech
import LocalAuthentication
import AVFoundation
import Foundation
import SystemConfiguration.CaptiveNetwork

extension UIButton {
    open override func draw(_ rect: CGRect) {
        //provide custom style
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}

class SecondViewController: UIViewController {
    var t_s = ""
    var t_h = ""
    var t_b = ""
    var t_g = ""
    var t_pool = ""
    var t_out = ""
    var P = ""
    var H = ""
    var timer: Timer!

    var action_dict:[Bool?: String] = [true: "SetStateOn", false: "SetStateOff", nil: "GetState"]

    var urlStr_piServer = ""
    let urlStr_remote_piServer = "http://88.247.53.31:3705"
    let urlStr_local_piServer  = "http://192.168.1.183:3704"
        
    var urlStr_wemoFan = ""
    let urlStr_remote_wemoFan = "http://88.247.53.31:130"
    let urlStr_local_wemoFan  = "http://192.168.1.130:49153"
    
    var urlStr_wemoHeater = ""
    let urlStr_remote_wemoHeater = "http://88.247.53.31:131"
    let urlStr_local_wemoHeater  = "http://192.168.1.131:49153"
    
    var urlStr_wemoSensors = ""
    let urlStr_remote_wemoSensors = "http://88.247.53.31:132"
    let urlStr_local_wemoSensors  = "http://192.168.1.132:49153"

    var urlStr_IRServer = ""
    let urlStr_local_IRServer = "http://192.168.1.177"
    let urlStr_remote_IRServer = "http://88.247.53.31:3708"

    var urlStr_envServer = ""
    let urlStr_local_envServer = "http://192.168.1.183:3704/env/env.html"
    let urlStr_remote_envServer = "http://88.247.53.31:3705/env/env.html"

    var urlStr_camServer = ""
    let urlStr_local_camServer = "http://192.168.1.187:3704/VideoSurv/vs.html"
    let urlStr_remote_camServer = "http://88.247.53.31:3707/VideoSurv/vs.html"

    var urlStr_logServer = ""
    let urlStr_local_logServer = "http://192.168.1.187:3704/env/logKalkan.php"
    let urlStr_remote_logServer = "http://88.247.53.31:3707/env/logKalkan.php"

    var urlStr_hueLights = "http://192.168.1.190"
    
    @IBOutlet weak var tHLbl: UILabel!
    @IBOutlet weak var tOLbl: UILabel!
    @IBOutlet weak var tBLbl: UILabel!
    @IBOutlet weak var tGLbl: UILabel!
    @IBOutlet weak var tSLbl: UILabel!
    @IBOutlet weak var tPLbl: UILabel!
    @IBOutlet weak var pLbl: UILabel!
    @IBOutlet weak var hLbl: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!    
    @IBAction func startBtnAction(_ sender: Any) {
        startBtn.isEnabled = false
        //clean buffer of synthesizer
        if synthesizer.isSpeaking{
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        vc_id = "vc_2"
        MySound(string: "Слушаю")
        textField.text = "Помедленнее... Я записую...."
        timer = Timer.scheduledTimer(withTimeInterval: 1.7, repeats: false, block: { (timer) in
            startRecognising()
        })
    }
    
    @IBOutlet weak var mdHallBtn: UIButton!
    @IBAction func mdHallAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        IRServer(urlStr: urlStr_IRServer, action: action_dict[!mdHallBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdHallBtn.isSelected = state!
                } else {
                    self.textField.text = "IRServer isn't connected !"
                }
            }
        }
    }
        
    @IBOutlet weak var hallLightsBtn: UIButton!
    @IBAction func hallLightsBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        lightHue(urlStr: urlStr_hueLights, lamp_id: 1, action: action_dict[!hallLight1Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight1Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 1 isn't connected !"
                }
            }
        }
        lightHue(urlStr: urlStr_hueLights, lamp_id: 2, action: action_dict[!hallLight2Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight2Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 2 isn't connected !"
                }
            }
        }
        lightPiHall(urlStr: urlStr_piServer, action: action_dict[!hallLight3Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight3Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 3 isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var hallLight1Btn: UIButton!
    @IBAction func hallLight1BtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        lightHue(urlStr: urlStr_hueLights, lamp_id: 1, action: action_dict[!hallLight1Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight1Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 1 isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var hallLight2Btn: UIButton!
    @IBAction func hallLight2BtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        lightHue(urlStr: urlStr_hueLights, lamp_id: 2, action: action_dict[!hallLight2Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight2Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 2 isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var hallLight3Btn: UIButton!
    @IBAction func hallLight3BtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        lightPiHall(urlStr: urlStr_piServer, action: action_dict[!hallLight3Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight3Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 3 isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var bedroomLightsBtn: UIButton!
    @IBAction func bedroomLightsBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        lightHue(urlStr: urlStr_hueLights, lamp_id: 3, action: action_dict[!bedroomLightsBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.bedroomLightsBtn.isSelected = state!
                } else {
                    self.textField.text = "Bedroom Lights isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var wemoFanBtn: UIButton!
    @IBAction func wemoFanBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        wemoSwitch(urlStr: urlStr_wemoFan, action: action_dict[!wemoFanBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoFanBtn.isSelected = state!
                } else {
                    self.textField.text = "Fan isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var wemoHeaterBtn: UIButton!
    @IBAction func wemoHeaterBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        wemoSwitch(urlStr: urlStr_wemoHeater, action: action_dict[!wemoHeaterBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoHeaterBtn.isSelected = state!
                } else {
                    self.textField.text = "Heater isn't connected !"
                }
            }
        }
    }
        
    @IBOutlet weak var wemoSensorsBtn: UIButton!
    @IBAction func wemoSensorsBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        print("wemo !", action_dict[wemoSensorsBtn.isSelected]!)
        wemoSwitch(urlStr: urlStr_wemoSensors, action: action_dict[!wemoSensorsBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoSensorsBtn.isSelected = state!
                } else {
                    self.textField.text = "Sensors isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var restartModemBtn: UIButton!
    @IBAction func restartModemBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        // create the alert
        let alert = UIAlertController(title: "Калкан Асистент", message: "Вы действительно готовы перегрузить модем?", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {action in
            restartModem(urlStr: self.urlStr_piServer)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var envBtn: UIButton!
    @IBAction func envBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        runSafary(urlStr: urlStr_envServer)
    }
    
    @IBOutlet weak var securityBtn: UIButton!
    @IBAction func securityBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        runSafary(urlStr: urlStr_camServer)
    }

    @IBOutlet weak var logBtn: UIButton!
    @IBAction func logBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        runSafary(urlStr: urlStr_logServer + "?msg=log")
        logBtn.isSelected = false
    }
        
    @objc func getStatusAllDevices() {
        // set urls depends of mode local/remote
        if pr_local {
            urlStr_wemoFan = urlStr_local_wemoFan
            urlStr_wemoHeater = urlStr_local_wemoHeater
            urlStr_wemoSensors = urlStr_local_wemoSensors
            urlStr_piServer = urlStr_local_piServer
            urlStr_IRServer = urlStr_local_IRServer
            urlStr_envServer = urlStr_local_envServer
            urlStr_camServer = urlStr_local_camServer
            urlStr_logServer = urlStr_local_logServer
        } else {
            urlStr_wemoFan = urlStr_remote_wemoFan
            urlStr_wemoHeater = urlStr_remote_wemoHeater
            urlStr_wemoSensors = urlStr_remote_wemoSensors
            urlStr_piServer = urlStr_remote_piServer
            urlStr_IRServer = urlStr_remote_IRServer
            urlStr_envServer = urlStr_remote_envServer
            urlStr_camServer = urlStr_remote_camServer
            urlStr_logServer = urlStr_remote_logServer
        }
        // get all info from envronment server
        getEnvironment(urlStr: urlStr_piServer){(data: String?) -> Void in
            if data != nil {
                let env_data = data!.split(separator: " ")
                self.t_s = String(env_data[2])
                self.t_g = String(env_data[3])
                self.t_h = String(env_data[4])
                self.t_b = String(env_data[5])
                self.t_out = String(env_data[6])
                self.t_pool = String(env_data[7])
                self.P = String(env_data[8])
                self.H = String(env_data[9])
                
                DispatchQueue.main.async { // Correct
                    self.tHLbl.text = self.t_h + "\u{00B0}" + "C"
                    self.tOLbl.text = self.t_out + "\u{00B0}" + "C"
                    self.tBLbl.text = self.t_b + "\u{00B0}" + "C"
                    self.tGLbl.text = self.t_g + "\u{00B0}" + "C"
                    self.tSLbl.text = self.t_s + "\u{00B0}" + "C"
                    self.tPLbl.text = self.t_pool + "\u{00B0}" + "C"
                    self.pLbl.text = self.P + "mm"
                    self.hLbl.text = self.H + "%"
                }
            } else {
                //                self.textField.text = "Error while reading sensors data !"
            }
        }
        
        // get all info from envronment IRServer
        IRServer(urlStr: urlStr_IRServer, action: "GetState"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    print(state!)
                    self.mdHallBtn.isSelected = state!
                } else {
                    self.textField.text = "IRServer isn't connected !"
                }
            }
        }
                

        lightPiHall(urlStr: urlStr_piServer, action: "GetState"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight3Btn.isSelected = state!
                } else {
                    self.textField.text = "Hall Lights 3 isn't connected !"
                }
            }
        }
        wemoSwitch(urlStr: urlStr_wemoFan, action: "GetState"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoFanBtn.isSelected = state!
                } else {
                    self.textField.text = "Fan isn't connected !"
                }
            }
        }
        wemoSwitch(urlStr: urlStr_wemoHeater, action: "GetState"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoHeaterBtn.isSelected = state!
                } else {
                    self.textField.text = "Heater isn't connected !"
                }
            }
        }
        wemoSwitch(urlStr: urlStr_wemoSensors, action: "GetState"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoSensorsBtn.isSelected = state!
                } else {
                    self.textField.text = "Sensors isn't connected !"
                }
            }
        }
        if pr_local {
            lightHue(urlStr: urlStr_hueLights, lamp_id: 1, action: "GetState"){(state: Bool?) -> Void in
                DispatchQueue.main.async {
                    if state != nil {
                        self.hallLight1Btn.isSelected = state!
                    } else {
                        self.textField.text = "Hall Lights 1 isn't connected !"
                    }
                }
            }
            lightHue(urlStr: urlStr_hueLights, lamp_id: 2, action: "GetState"){(state: Bool?) -> Void in
                DispatchQueue.main.async {
                    if state != nil {
                        self.hallLight2Btn.isSelected = state!
                    } else {
                        self.textField.text = "Hall Lights 2 isn't connected !"
                    }
                }
            }
            lightHue(urlStr: urlStr_hueLights, lamp_id: 3, action: "GetState"){(state: Bool?) -> Void in
                DispatchQueue.main.async {
                    if state != nil {
                        self.bedroomLightsBtn.isSelected = state!
                    } else {
                        self.textField.text = "Bedroom Lights isn't connected !"
                    }
                }
            }
            //            ir_sender(urlStr: urlStr_irSender, action: "tst")
        }
        // set available buttons in local/remote mode
        for (_, button) in localBtns.enumerated() {
            button.isEnabled = pr_local
        }
    }

    @objc func cmd_executor() {
        self.textField.text = res_text
        startBtn!.isEnabled = true
        task_exec(cmd: res_text)
    }

    func task_exec(cmd: String) {
        var a = ""
        var b = ""
        switch cmd {
        case "Кто ты", "Как тебя зовут":
            MySound(string: "Я есть программа калкан ассистент версия 1.0")
            MySound(string: "мой создатель великий и могучий дау")
        case "Кто твой хозяин":
            MySound(string: "мой хозяин великий и могучий дау")
        case "Кто моя жена":
            MySound(string: "Ваша жена Валентина малипусенькая")
        case "Температура в зале", "Температура в холле":
            a = String(format: "%.0f", Float(t_h)!)
            b = end_suffix(value: t_h, word: "градус")
            MySound(string: "Температура в зале " + a + b)
        case "Температура в спальне":
            a = String(format: "%.0f", Float(t_b)!)
            b = end_suffix(value: t_b, word: "градус")
            MySound(string: "Температура в спальне " + a + b)
        case "Температура на первом этаже":
            a = String(format: "%.0f", Float(t_g)!)
            b = end_suffix(value: t_g, word: "градус")
            MySound(string: "Температура на первом этаже " + a + b)
        case "Температура снаружи", "Температура на улице":
            a = String(format: "%.0f", Float(t_out)!)
            b = end_suffix(value: t_out, word: "градус")
            MySound(string: "Температура снаружи " + a + b)
        case "Температура воды в бассейне":
            a = String(format: "%.0f", Float(t_pool)!)
            b = end_suffix(value: t_pool, word: "градус")
            MySound(string: "Температура воды в бассейне " + a + b)
        case "Атмосферное давление":
            a = String(format: "%.0f", Float(P)!)
            b = end_suffix(value: P, word: "миллиметр")
            MySound(string: "Атмосферное давление "  + a + b + " ртутного столба")
        case "Влажность", "Влажность воздуха":
            a = String(format: "%.0f", Float(H)!)
            b = end_suffix(value: H, word: "процент")
            MySound(string: "Влажность воздуха "  + a + b)
        case "Рапорт":
            MySound(string: "Калкан ассистент докладывает")
            a = String(format: "%.0f", Float(t_h)!)
            b = end_suffix(value: t_h, word: "градус")
            MySound(string: "Температура в зале " + a + b)
            a = String(format: "%.0f", Float(t_b)!)
            b = end_suffix(value: t_b, word: "градус")
            MySound(string: "Температура в спальне " + a + b)
            a = String(format: "%.0f", Float(t_g)!)
            b = end_suffix(value: t_g, word: "градус")
            MySound(string: "Температура на первом этаже " + a + b)
            a = String(format: "%.0f", Float(t_out)!)
            b = end_suffix(value: t_out, word: "градус")
            MySound(string: "Температура снаружи " + a + b)
            a = String(format: "%.0f", Float(t_pool)!)
            b = end_suffix(value: t_pool, word: "градус")
            MySound(string: "Температура воды в бассейне " + a + b)
            a = String(format: "%.0f", Float(P)!)
            b = end_suffix(value: P, word: "миллиметр")
            MySound(string: "Атмосферное давление "  + a + b + " ртутного столба")
            a = String(format: "%.0f", Float(H)!)
            b = end_suffix(value: H, word: "процент")
            MySound(string: "Влажность воздуха "  + a + b)
            MySound(string: "Доклад окончен")
        case "Свет в зале", "Свет зал":
            if pr_local {
                MySound(string: "Выполняю")
                hallLightsBtnAction("z")
            } else {
                MySound(string: "Извините но эта функция доступна только в локальной сети Калкана")
            }
        case "Лампа один в зале", "Лампа один зал":
            if pr_local {
                MySound(string: "Выполняю")
                hallLight1BtnAction("z")
            } else {
                MySound(string: "Извините но эта функция доступна только в локальной сети Калкана")
            }
        case "Лампа два в зале", "Лампа два зал":
            if pr_local {
                MySound(string: "Выполняю")
                hallLight2BtnAction("z")
            } else {
                MySound(string: "Извините но эта функция доступна только в локальной сети Калкана")
            }
        case "Лампа три в зале", "Лампа три зал":
            //            if pr_local {
            MySound(string: "Выполняю")
            hallLight3BtnAction("z")
            //            } else {
            //                MySound(string: "Извините но эта функция доступна только в локальной сети Калкана")
        //            }
        case "Свет в спальне", "Свет спальня":
            if pr_local {
                MySound(string: "Выполняю")
                bedroomLightsBtnAction("z")
            } else {
                MySound(string: "Извините но эта функция доступна только в локальной сети Калкана")
            }
        case "Вентилятор":
            MySound(string: "Выполняю")
            wemoFanBtnAction("z")
        case "Обогреватель":
            MySound(string: "Выполняю")
            wemoHeaterBtnAction("z")
        case "Cервер ардуино", "Arduino сервер":
            MySound(string: "Выполняю")
            wemoSensorsBtnAction("z")
        case "Перегрузить модем", "Модем перегрузить":
            MySound(string: "Выполняю")
            restartModemBtnAction("z")
        case "Домашняя обстановка", "Обстановка дома":
            envBtnAction("z")
        case "Видеонаблюдение", "Видео наблюдения":
            securityBtnAction("z")
        default:
            MySound(string: "Извините но я не волшебница, я могу исполнить только ограниченный список команд")
        }
            startBtn.isEnabled = true
    }

    
    func runSafary(urlStr: String) {
        guard let url = NSURL(string: urlStr) else {
            return
        }
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set Notification server for restart getStatusAllDevices on every entry time
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getStatusAllDevices),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)

        // setup Notification server to start cmd_executor after scpeech recognition
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self,
                                  selector: #selector(cmd_executor),
                                  name: NSNotification.Name(rawValue: "vc_2"),
                                  object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        getSSID()
        getStatusAllDevices()
        // get pr_modify from logServer
        getStatusLogFile()
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // stop restart getStatusLogFile
        stopTimer()
        super.viewWillDisappear(animated)
    }
    
    @objc func getStatusLogFile(){
        statusLogFile(urlStr: urlStr_logServer){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    print(state!)
                    self.logBtn.isSelected = state!
                } else {
                    self.textField.text = "IRServer isn't connected !"
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0,
                                     target: self,
                                     selector: #selector(getStatusLogFile),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
        timer = nil
    }

}

