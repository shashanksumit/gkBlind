//
//  ViewController.swift
//  gkBlind
//
//  Created by CG-3 on 23/01/17.
//  Copyright © 2017 CG-3. All rights reserved.
//

import UIKit
import CoreData
import Speech
import AVFoundation

class ViewController: UIViewController, SFSpeechRecognizerDelegate
{
    
    var option = [NSManagedObject]()
    let speakTalk = AVSpeechSynthesizer()
    @IBOutlet weak var swipeLabel: UILabel!
    
    var optionsoundcatch: String = " "
    var speak: String = ""
    let audioSession = AVAudioSession.sharedInstance()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
        func WelcomeSpeach()
    {
        
        let speakText = AVSpeechUtterance(string: "Hello . . . . Welcome to Blind Quiz . . . Swipe Left For Start Game . . . Swipe Right For Rule")
        speakText.rate = 0.4 
        speakText.preUtteranceDelay = 1
        speakText.pitchMultiplier = 1.72
        speakTalk.speak(speakText)
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        WelcomeSpeach()
        tapPressed()
        
        
   }
    
    override public func viewDidAppear(_ animated: Bool)
    {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
                    
                case .denied:
                    break
                    
                case .restricted:
                    
                    print("Speech recognition restricted on this device")
                    break
                    
                case .notDetermined:
                    
                    print("Speech recognition not yet authorized")
                    break
                }
            }
        }
        
    }

    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        speakTalk.stopSpeaking(at:AVSpeechBoundary.immediate)
    }
    
    func startRecording() throws
    {
        //  print("Speak For Recording")
        
        do
        {
            //let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        print("Recognition request")
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        print("Before Recognition Finished")
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.optionsoundcatch = result.bestTranscription.formattedString
                isFinal = result.isFinal
                //print("\(result)")
                self.speak = "\(self.optionsoundcatch)"
                print("\(self.speak)")
            }
            var tag: Int = 0
            if self.speak.contains("Start")  //|| self.speak.contains("1") || self.speak.contains("one")
            {
                tag = 1
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                btnsendtag.sendActions(for: .touchUpInside)
                self.optionsoundcatch = ""
                
            }
            
            if self.speak.contains("Rules")  || self.speak.contains("rules") //|| self.speak.contains("one")
            {
                tag = 2
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                btnsendtag.sendActions(for: .touchUpInside)
                self.optionsoundcatch = ""
                
            }

            
                        if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                // print("\(self.optionsoundcatch)")
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                print("recognition Task nilled")
                self.optionsoundcatch = ""
                print("\(self.optionsoundcatch)")
                
               // self.recordingButton.isEnabled = true
                // self.recordingButton.setTitle("Start Recording", for: [])
            }
            
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool)
    {
        if available
        {
           // recordingButton.isEnabled = true
        }
        else
        {
           // recordingButton.isEnabled = false
        }
    }

    func tapPressed()
    {
        let selector : Selector = "tapFunc"
        let tapGuesture = UITapGestureRecognizer(target : self, action : selector)
        tapGuesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGuesture)
        
        
    }
    func tapFunc()
    {
        print("Tapped")
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            // recordingButton.isEnabled = false
            if let recognitionTask = recognitionTask {
                recognitionTask.cancel()
                self.recognitionTask = nil
            }
            print("Audio Engine Stop")
            self.optionsoundcatch = ""
        }
        else
        {
            try! startRecording()
            print("Audio Engine Started")
            //self.optionsoundcatch = ""
            
        }
    }
    
}

