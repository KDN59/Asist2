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

    var urlStr_KalkanServer = ""
    let urlStr_remote_KalkanServer = "http://88.247.53.31:3707"
    let urlStr_local_KalkanServer  = "http://192.168.1.187:3704/Kalkan/KalkanServer.php?msg="

    var mdPirHall_action:[Bool: String] =     [true: "set_mdPirHall_on", false: "set_mdPirHall_off"]
    var mdPirSRoom_action:[Bool: String] =    [true: "set_mdPirSRoom_on", false: "set_mdPirSRoom_off"]
    var mdPirEntrance_action:[Bool: String] = [true: "set_mdPirEntrance_on", false: "set_mdPirEntrance_off"]
    var mdPirKitchen_action:[Bool: String] =  [true: "set_mdPirKitchen_on", false: "set_mdPirKitchen_off"]
    var HallLight_1_action:[Bool: String] =   [true: "set_HueLight_1_on", false: "set_HueLight_1_off"]
    var HallLight_2_action:[Bool: String] =   [true: "set_HueLight_2_on", false: "set_HueLight_2_off"]
    var HallLight_3_action:[Bool: String] =   [true: "set_RPiLight_on", false: "set_RPiLight_off"]
    var BedRoom_action:[Bool: String] =       [true: "set_HueLight_3_on", false: "set_HueLight_3_off"]
    var WemoSwitchFan_action:[Bool: String] =    [true: "set_wemoSwitch_Fan_on", false: "set_wemoSwitch_Fan_off"]
    var WemoSwitchSensor_action:[Bool: String] = [true: "set_wemoSwitch_Sensor_on", false: "set_wemoSwitch_Sensor_off"]
    var WemoSwitchHeater_action:[Bool: String] = [true: "set_wemoSwitch_Heater_on", false: "set_wemoSwitch_Heater_off"]

    
    var urlStr_piServer = ""
    let urlStr_remote_piServer = "http://88.247.53.31:3705"
    let urlStr_local_piServer  = "http://192.168.1.183:3704"
            
    var urlStr_envServer = ""
    let urlStr_local_envServer = "http://192.168.1.183:3704/env/env.html"
    let urlStr_remote_envServer = "http://88.247.53.31:3705/env/env.html"

    var urlStr_camServer = ""
    let urlStr_local_camServer = "http://192.168.1.187:3704/VideoSurv/vs.html"
    let urlStr_remote_camServer = "http://88.247.53.31:3707/VideoSurv/vs.html"

    var urlStr_logServer = ""
    let urlStr_local_logServer = "http://192.168.1.187:3704/Kalkan/logKalkan.html"
    let urlStr_remote_logServer = "http://88.247.53.31:3707/Kalkan/logKalkan.html"
    
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
        KalkanServer(url_cmd: urlStr_KalkanServer + mdPirHall_action[!mdHallBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdHallBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirHall isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var mdServerRoomBtn: UIButton!
    @IBAction func mdServerRoomAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + mdPirSRoom_action[!mdServerRoomBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdServerRoomBtn.isSelected = state!
                } else {
                    self.textField.text = "mdSRoom isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var mdEntranceBtn: UIButton!
    @IBAction func mdEntranceAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + mdPirEntrance_action[!mdEntranceBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdEntranceBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirEntrance isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var mdKitchenBtn: UIButton!
    @IBAction func mdKitchenAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + mdPirKitchen_action[!mdKitchenBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdKitchenBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirHall isn't connected !"
                }
            }
        }
    }

    @IBOutlet weak var hallLight1Btn: UIButton!
    @IBAction func hallLight1BtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + HallLight_1_action[!hallLight1Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight1Btn.isSelected = state!
                } else {
                    self.textField.text = "HallLight 1 isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var hallLight2Btn: UIButton!
    @IBAction func hallLight2BtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + HallLight_2_action[!hallLight2Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight2Btn.isSelected = state!
                } else {
                    self.textField.text = "HallLight 2 isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var hallLight3Btn: UIButton!
    @IBAction func hallLight3BtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + HallLight_3_action[!hallLight3Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight3Btn.isSelected = state!
                } else {
                    self.textField.text = "RPiLight isn't connected !"
                }
            }
        }
    }

    @IBOutlet weak var hallLightsBtn: UIButton!
    @IBAction func hallLightsBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        // on/off lightHall 1
        KalkanServer(url_cmd: urlStr_KalkanServer + HallLight_1_action[!hallLight1Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight1Btn.isSelected = state!
                } else {
                    self.textField.text = "HallLight 1 isn't connected !"
                }
            }
        }

        // on/off lightHall 2
        KalkanServer(url_cmd: urlStr_KalkanServer + HallLight_2_action[!hallLight2Btn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight2Btn.isSelected = state!
                } else {
                    self.textField.text = "HallLight 2 isn't connected !"
                }
            }
        }

        // on/off lightPiHall
            KalkanServer(url_cmd: urlStr_KalkanServer + HallLight_3_action[!hallLight3Btn.isSelected]!){(state: Bool?) -> Void in
                DispatchQueue.main.async {
                    if state != nil {
                        self.hallLight3Btn.isSelected = state!
                    } else {
                        self.textField.text = "RPiLight isn't connected !"
                    }
                }
            }
    }
        
    @IBOutlet weak var bedroomLightsBtn: UIButton!
    @IBAction func bedroomLightsBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + BedRoom_action[!bedroomLightsBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.bedroomLightsBtn.isSelected = state!
                } else {
                    self.textField.text = "BedRoom Light isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var wemoFanBtn: UIButton!
    @IBAction func wemoFanBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + WemoSwitchFan_action[!wemoFanBtn.isSelected]!){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoFanBtn.isSelected = state!
                } else {
                    self.textField.text = "WemoFan isn't connected !"
                }
            }
        }
    }
    
    @IBOutlet weak var wemoHeaterBtn: UIButton!
    @IBAction func wemoHeaterBtnAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(1057))
        KalkanServer(url_cmd: urlStr_KalkanServer + WemoSwitchHeater_action[!wemoHeaterBtn.isSelected]!){(state: Bool?) -> Void in
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
        KalkanServer(url_cmd: urlStr_KalkanServer + WemoSwitchSensor_action[!wemoSensorsBtn.isSelected]!){(state: Bool?) -> Void in
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
        runSafary(urlStr: urlStr_logServer)
        logBtn.isSelected = false
    }
        
    @objc func getStatusAllDevices() {
        // set urls depends of mode local/remote
        if pr_local {
            urlStr_KalkanServer = urlStr_local_KalkanServer
            urlStr_piServer = urlStr_local_piServer
            urlStr_envServer = urlStr_local_envServer
            urlStr_camServer = urlStr_local_camServer
            urlStr_logServer = urlStr_local_logServer
        } else {
            urlStr_KalkanServer = urlStr_remote_KalkanServer
            urlStr_piServer = urlStr_remote_piServer
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
        
        // get state mdPirHall
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_mdPirHall"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdHallBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirHall isn't connected !"
                }
            }
        }
 
        // get state mdPirKitchen
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_mdPirKitchen"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdKitchenBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirKitchen isn't connected !"
                }
            }
        }

        // get state mdPirSRoom
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_mdPirSRoom"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdServerRoomBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirSRoom isn't connected !"
                }
            }
        }

        // get state mdPirEntrance
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_mdPirEntrance"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.mdEntranceBtn.isSelected = state!
                } else {
                    self.textField.text = "mdPirEntrance isn't connected !"
                }
            }
        }

        // get state RPiLightHall
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_RPiLight"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight3Btn.isSelected = state!
                } else {
                    self.textField.text = "HallRPiLight isn't connected !"
                }
            }
        }

        // get state HuelightHall 1
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_HueLight_1"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight1Btn.isSelected = state!
                } else {
                    self.textField.text = "HallHueLight 1 isn't connected !"
                }
            }
        }

        // get state HuelightHall 2
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_HueLight_2"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.hallLight2Btn.isSelected = state!
                } else {
                    self.textField.text = "HallHueLight 2 isn't connected !"
                }
            }
        }

        // get state BedRoomLight
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_HueLight_3"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.bedroomLightsBtn.isSelected = state!
                } else {
                    self.textField.text = "BedRoom Light isn't connected !"
                }
            }
        }

        // get wemoSwitchFan status
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_wemoSwitch_Fan"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoFanBtn.isSelected = state!
                } else {
                    self.textField.text = "WemoFan isn't connected !"
                }
            }
        }

        // get wemoSwitchHeater status
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_wemoSwitch_Heater"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoHeaterBtn.isSelected = state!
                } else {
                    self.textField.text = "Heater isn't connected !"
                }
            }
        }
        
        // get wemoSwitchSensors status
        KalkanServer(url_cmd: urlStr_KalkanServer + "get_wemoSwitch_Sensor"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.wemoSensorsBtn.isSelected = state!
                } else {
                    self.textField.text = "Sensors isn't connected !"
                }
            }
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
        KalkanServer(url_cmd: urlStr_KalkanServer + "status"){(state: Bool?) -> Void in
            DispatchQueue.main.async {
                if state != nil {
                    self.logBtn.isSelected = state!
                } else {
                    self.textField.text = "logServer isn't connected !"
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

