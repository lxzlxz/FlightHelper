//
//  TranslatorViewController.swift
//  1
//  Coding logic: Voice -> Text (same language)
//          then: text(language you speak) -> text(language you want to translate to)

//  Created by yzn123 on 12/4/18.
//  Copyright © 2018 Zhennan Yao. All rights reserved.
//

import UIKit
import Speech
class TranslatorViewController: UIViewController, SFSpeechRecognizerDelegate{

    //whole name of language translated from
    var typeF = ""
    //whole name of language translated to
    var typeT = ""
    //abbreviated name of language translated from
    var fLan = ""
    //abbreviated name of language translated to
    var tLan = ""
    //display the language user speaks
    @IBOutlet var fromText: UITextView!
    //displat the translated result of targeting language
    @IBOutlet var toText: UITextView!
    
    //record button to record voice
    @IBOutlet var recordButton: UIButton!
    //speech recognizer
    var speech = SFSpeechRecognizer()
    //recognition request
    var recogRequest: SFSpeechAudioBufferRecognitionRequest?
    //recognition task
    var recogTask: SFSpeechRecognitionTask?
    //audio engine
    let audio = AVAudioEngine()
    //hold the translated json data
    var translatedJasonData = Dictionary<String, AnyObject>()
    let languageDictionary = ["Malayalam" : "ml",
                              "English" : "en",
                              "Arabic" : "ar",
                              "Armenian" : "hy",
                              "Afrikaans" : "af",
                              "Basque" : "eu",
                              "German" : "de",
                              "Bulgarian" : "bg",
                              "Persian" : "fa",
                              "Polish" : "pl",
                              "Welsh" : "cy",
                              "Portuguese" : "pt",
                              "Hungarian" : "hu",
                              "Romanian" : "ro",
                              "Vietnamese" : "vi",
                              "Russian" : "ru",
                              "Greek" : "el",
                              "Thai" : "th",
                              "Indonesian" : "id",
                              "Italian" : "it",
                              "Turkish" : "tr",
                              "Spanish" : "es",
                              "Chinese" : "zh",
                              "French" : "fr",
                              "Korean" : "ko",
                              "Hindi" : "hi",
                              "Swedish" : "sv",
                              "Japanese" : "ja"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (typeF == typeT) {
            self.showAlertMessage(messageHeader: "Denied", messageBody: "Please translate different type of languages!")
            return
        }
        
        if (languageDictionary[typeF] == nil || languageDictionary[typeT] == nil || typeF == nil || typeT == nil) {
            self.showAlertMessage(messageHeader: "Denied", messageBody: "Please picker another pair of languages!")
            return
        }
        fLan = languageDictionary[typeF]!
        tLan = languageDictionary[typeT]!
        if (SFSpeechRecognizer(locale: Locale.init(identifier: fLan)) == nil) {
            showAlertMessage(messageHeader: "Locale doesn't support this language", messageBody: "choose another language!")
            return
        }
        
        speech = SFSpeechRecognizer(locale: Locale.init(identifier: fLan))
        
        recordButton.isEnabled = false
        speech!.delegate = self
        //authorize the speech recognizer request
        SFSpeechRecognizer.requestAuthorization { (Status) in
            
            var isRecordButtonEnabled = false
            switch Status {
            case .authorized:
                isRecordButtonEnabled = true
                
            case .denied:
                isRecordButtonEnabled = false
                self.showAlertMessage(messageHeader: "Denied", messageBody: "You denied the authorization of your voice!")
                return
                
            case .restricted:
                isRecordButtonEnabled = false
                self.showAlertMessage(messageHeader: "Restricted", messageBody: "Not Authorized")
                return
                
            case .notDetermined:
                isRecordButtonEnabled = false
                self.showAlertMessage(messageHeader: "Not Determined", messageBody: "Not Authorized")
                return
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isRecordButtonEnabled
            }
        }

        // Do any additional setup after loading the view.
    }
    //when record button tapped
    @IBAction func recordTapped(_ sender: UIButton) {
        if audio.isRunning {
            //when one recording is successful
            audio.stop()
            recogRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("record again", for: .normal)
           
        } else {
            //recording
            Record()
            recordButton.setTitle("finish", for: .normal)
            
        }
    }
    //recording task
    func Record() {

        if recogTask != nil {
            recogTask?.cancel()
            recogTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.showAlertMessage(messageHeader: "Denied", messageBody: "Error!")
            
        }

        recogRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audio.inputNode
        

        guard let recogRequest = recogRequest else {
            self.showAlertMessage(messageHeader: "Error", messageBody: "Unable to request the recognition!")
            return
            
        }

        recogRequest.shouldReportPartialResults = true

        recogTask = speech!.recognitionTask(with: recogRequest, resultHandler: { (result, error) in

            var final = false

            if result != nil {

                self.fromText.text = result?.bestTranscription.formattedString
                final = (result?.isFinal)!
            }

            if error != nil || final {
                self.audio.stop()
                inputNode.removeTap(onBus: 0)

                self.recogRequest = nil
                self.recogTask = nil

                self.recordButton.isEnabled = true

                let selectedLanguage = self.fLan
                let languageDirection = selectedLanguage + "-" + self.tLan
                let transcriptionText = result?.bestTranscription.formattedString
                if transcriptionText == nil
                {
                    self.showAlertMessage(messageHeader: "Unrecognized voice", messageBody: "Too far to the microphone. Try again!")
                    return
                }
                //read another JSON to translate text to text in another language
                let apiKey = "&key=trnsl.1.1.20181204T192628Z.3887e5dcc4d3f8e5.979f2fbdd1d53a984dc2337542ecbba9a610a2be"
                let textReadyToTranslate = "&text=" + transcriptionText!
                var requestURL = "https://translate.yandex.net/api/v1.5/tr.json/translate?lang=" + languageDirection + apiKey + textReadyToTranslate
                requestURL = requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let url = URL(string: requestURL)
                if url == nil
                {
                    self.showAlertMessage(messageHeader: "Invalid voice", messageBody: "Your transcripted text may contain special character that added automatically by Apple Speech translation, please say the destination again")
                    return
                }

                var jsonData: Data?
                do {
                    jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)

                } catch {
                    self.showAlertMessage(messageHeader: "Unrecognized news api url", messageBody: "Please make sure the api url is correct")
                }

                if let jsonDataFromApiUrl = jsonData {
                    do{
                        let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

                        // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                        let dictionaryOfTranslatedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                        self.translatedJasonData = dictionaryOfTranslatedJsonData
                        let translatedLanguage = self.translatedJasonData["text"] as! NSArray

                        self.toText.text = translatedLanguage[0] as? String

                    }
                    catch let error as NSError {

                        self.showAlertMessage(messageHeader: "JSON Data", messageBody: "Error in JSON Data Serialization: \(error.localizedDescription)")

                    }
                }
                else {
                    self.showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the JSON data file!")

                }
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recogRequest?.append(buffer)
        }

        audio.prepare()

        do {
            try audio.start()
        } catch {
            self.showAlertMessage(messageHeader: "Error", messageBody: "audio cannot start recording.")
        }


        
    }
    //recognize whether recordbutton is enabled
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

}
