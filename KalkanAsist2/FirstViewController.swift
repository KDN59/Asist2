//
//  FirstViewController.swift
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
import CoreLocation


let urlStr_irSender = "http://192.168.1.177"

var pr_local = false
var timer = Timer()
// define buttons working only in local mode
var localBtns:Array<UIButton> = []

// var for sounds
var synthesizer  = AVSpeechSynthesizer()
var audioPlayer: AVAudioPlayer?

//var for speech recognise
let audioSession = AVAudioSession.sharedInstance()
let audioEngine = AVAudioEngine()
let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
var recognitionTask: SFSpeechRecognitionTask?

var res_text = ""
var vc_id = ""
var pr_voice_recog = false {
    didSet {
        let defaultCenter = NotificationCenter.default
        defaultCenter.post(
            name: NSNotification.Name(vc_id),
            object: nil,
            userInfo: nil)
    }
}

var locationManager = CLLocationManager()
var currentNetworkInfos: Array<NetworkInfo>? {
    get {
        return SSID.fetchNetworkInfo()
    }
}

class FirstViewController: UIViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var startBtn: UIButton!    
    @IBAction func startBtnAction(_ sender: Any) {
        startBtn.isEnabled = false
        if !pr_local {return}
        //clean buffer of synthesizer
        if synthesizer.isSpeaking{
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        vc_id = "vc_1"
        MySound(string: "Слушаю")
        startBtn.setTitle("Жду голосовую команду ...", for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        timer = Timer.scheduledTimer(withTimeInterval: 1.7, repeats: false, block: { (timer) in
            startRecognising()
        })
    }
    
    @IBOutlet weak var tv_systemBtn: UIButton!
    @IBAction func tv_systemBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_TVSYSTEM")
    }
    
    @IBOutlet weak var reciverBtn: UIButton!
    @IBAction func reciverBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Rcv")
    }
    
    @IBOutlet weak var tvBtn: UIButton!
    @IBAction func tvBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_TV")
    }
    
    @IBOutlet weak var ampBtn: UIButton!
    @IBAction func ampBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Amp")
    }
    
    @IBOutlet weak var c0Btn: UIButton!
    @IBAction func c0BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C0")
    }
    @IBOutlet weak var c1Btn: UIButton!
    @IBAction func c1BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C1")
    }
    @IBOutlet weak var c2Btn: UIButton!
    @IBAction func c2BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C2")
    }
    @IBOutlet weak var c3Btn: UIButton!
    @IBAction func c3BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C3")
    }
    @IBOutlet weak var c4Btn: UIButton!
    @IBAction func c4BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C4")
    }
    @IBOutlet weak var c5Btn: UIButton!
    @IBAction func c5BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C5")
    }
    @IBOutlet weak var c6Btn: UIButton!
    @IBAction func c6BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C6")
    }
    @IBOutlet weak var c7Btn: UIButton!
    @IBAction func c7BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C7")
    }
    @IBOutlet weak var c8Btn: UIButton!
    @IBAction func c8BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C8")
    }
    @IBOutlet weak var c9Btn: UIButton!
    @IBAction func c9BtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C9")
    }
    
    @IBOutlet weak var chanelPlusBtn: UIButton!
    @IBAction func chanelPlusBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C+")
    }
    
    @IBOutlet weak var chanelMinusBtn: UIButton!
    @IBAction func chanelMinusBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_C-")
    }
    
    @IBOutlet weak var volPlusBtn: UIButton!
    @IBAction func volPlusBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Vol+")
    }
    
    @IBOutlet weak var volMinusBtn: UIButton!
    @IBAction func volMinusBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Vol-")
    }
    
    @IBOutlet weak var muteBtn: UIButton!
    @IBAction func muteBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Mute")
    }
    
    @IBOutlet weak var okBtn: UIButton!
    @IBAction func okBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Ok")
    }

    @IBOutlet weak var upBtn: UIButton!
    @IBAction func upBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Up")
    }
    
    @IBOutlet weak var downBtn: UIButton!
    @IBAction func downBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Down")
    }
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBAction func leftBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Left")
    }
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBAction func rightBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Right")
    }

    @IBOutlet weak var menuBtn: UIButton!
    @IBAction func menuBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Menu")
    }
    
    @IBOutlet weak var exitBtn: UIButton!
    @IBAction func exitBtnAction(_ sender: Any) {
        ir_sender(urlStr: urlStr_irSender, action: "IR_Exit")
    }
    

    @objc func cmd_executor() {
        startBtn.setTitle(res_text, for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        startBtn!.isEnabled = true
        task_exec(cmd: res_text)
    }
    
    func task_exec(cmd: String) {
        switch cmd {
        case "Кто ты", "Как тебя зовут":
            MySound(string: "Я есть программа калкан ассистент версия 1.0")
            MySound(string: "мой создатель великий и могучий дау")
        case "Кто твой хозяин":
            MySound(string: "мой хозяин великий и могучий дау")
        case "Кто моя жена":
            MySound(string: "Ваша жена Валентина малипусенькая")
        case "Кинотеатор", "Кинотеатр" :
            tv_systemBtnAction("z")
        case "Телевизор":
            tvBtnAction("z")
        case "Ресивер":
            reciverBtnAction("z")
        case "Усилитель":
            ampBtnAction("z")
        case "Увеличить громкость", "Добавить звук", "Громче":
            volPlusBtnAction("z")
        case "Уменьшить громкость", "Убавить звук", "Тише":
            volMinusBtnAction("z")
        case "Включить звук", "Выключить звук", "Включи звук", "Выключи звук":
            muteBtnAction("z")
        case "Канал один", "Первый канал":
            c1BtnAction("z")
        case "Канал два", "Второй канал":
            c2BtnAction("z")
        case "Канал три", "Третий канал":
            c3BtnAction("z")
        case "Канал четыре", "Четвёртый канал":
            c4BtnAction("z")
        case "Канал пять", "Пятый канал":
            c5BtnAction("z")
        case "Канал шесть", "Шестой канал":
            c6BtnAction("z")
        case "Канал семь", "Седьмой канал":
            c7BtnAction("z")
        case "Канал восемь", "Восьмой канал":
            c8BtnAction("z")
        case "Канал девять", "Девятый канал":
            c9BtnAction("z")
        case "Канал ноль", "Нулевой канал":
            c0BtnAction("z")
        case "Канал плюс":
            chanelPlusBtnAction("z")
        case "Канал минус":
            chanelMinusBtnAction("z")
        case "Окей":
            okBtnAction("z")
        case "Влево", "Лево":
            leftBtnAction("z")
        case "Вправо", "Право":
            rightBtnAction("z")
        case "Вверх", "Верх":
            upBtnAction("z")
        case "Вниз", "Низ":
            downBtnAction("z")
        case "Меню":
            menuBtnAction("z")
        case "Выход":
            exitBtnAction("z")
        default:
            MySound(string: "Извините но я не волшебница, я могу исполнить только ограниченный список команд")
        }
        startBtn.isEnabled = true
//        startBtn.setTitle("Start", for: .normal)
//        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }

    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        MySound(string: "Здравствуйте великий и могучий Дау. Калкан ассистент готов к работе")
                        self.startBtn.isEnabled = true
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        localBtns = [startBtn, tv_systemBtn, reciverBtn, tvBtn, ampBtn,
                     c0Btn, c1Btn, c2Btn, c3Btn, c4Btn, c5Btn,
                     c6Btn, c7Btn, c8Btn, c9Btn,
                     chanelPlusBtn, chanelMinusBtn, muteBtn, volPlusBtn, volMinusBtn,
                     okBtn, upBtn, leftBtn, rightBtn, downBtn, menuBtn, exitBtn]
        getSSID()
        if !pr_local {return} // exit if not detected Kalkan WiFi
        // set the delegate
        synthesizer.delegate = self
        startBtn.isEnabled = false
        
        SFSpeechRecognizer.requestAuthorization {
            status in
            switch status {
            case .authorized:
                print("Разрешение на распознание речи получено!")
            case .denied:
                print("Пользователь не дал разрешения на использование распознавания речи")
            case .notDetermined:
                print("Распознавание речи еще не разрешено пользователем")
            case .restricted:
                print("Распознавание речи не поддерживается на этом устройстве")
            @unknown default:
                print("Неизвестная ошибка")
            }
        }
        // setup sounds ---
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioSession.overrideOutputAudioPort(.speaker)
        } catch {
            print("Не удалось настроить аудиосессию")
        }
        MySound(string: "Необходимо идентифицировать пользователя")
        authenticateUser()
        // setup Notification server to start cmd_executor after scpeech recognition
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self,
            selector: #selector(cmd_executor),
            name: NSNotification.Name(rawValue: "vc_1"),
            object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        getSSID()
        if pr_local {
            startBtn.setTitle("S T A R T", for: .normal)
            startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        } else {
            startBtn.setTitle("Kalkan WiFi not Detected !", for: .normal)
            startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        }
        // set available buttons in local/remote mode
        for (_, button) in localBtns.enumerated() {
            button.isEnabled = pr_local
        }
    }

    // will be called when speech did finish
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (startBtn.isEnabled) {
            startBtn.setTitle("S T A R T", for: .normal)
            startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        }
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
}
