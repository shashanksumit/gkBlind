//
//  QAViewController.swift
//  gkBlind
//
//  Created by CG-3 on 30/01/17.
//  Copyright © 2017 CG-3. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Speech
import AVFoundation

public class QAViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    
    // *************************Global Variables******************
    //var returnValue : Bool = false
    var optionsoundcatch: String = " "
    var speak: String = ""
    let speakTalk = AVSpeechSynthesizer()
    var IsOption: [Bool] = []
    var IsSelected: [Bool] = []
    var arrayOfOptionButton:[UIButton] = []
    var Points: Int = 0
    var myStringValue:String?
    var QuestionId: Int = 1
    var count:Int = 0
    var option_Count = 0
    var optionno = 0
    var foutput : Bool = false
    var option1 :Bool = false
    var option2 :Bool = false
    var option3 :Bool = false
    var option4 :Bool = false
    var option5 :Bool = false
    //let audioSession = AVAudioSession.sharedInstance()
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var OptionScroll: UIScrollView!
    @IBOutlet weak var lblScore: UILabel!
    
    //@IBOutlet weak var recordingButton: UIButton!
    ///speech
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // *************************Function for Audio Setting ******************
    func Audio(Input : String)
    {
            let speakText = AVSpeechUtterance(string: "\(Input)")
            speakText.rate = 0.5
            speakText.pitchMultiplier = 1.7
            speakTalk.speak(speakText)


    }
    // *************************Main View ******************
    
     public override func viewDidLoad()
     {
        super.viewDidLoad()
        tapPressed()
        
        QuestionCount()
        optionCount()
        print ("executed view didload")
        loadQuestion(QuestionId: QuestionId)
        
       // recordingButton.isEnabled = false
        
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
                  //  self.recordingButton.isEnabled = true
                    //self.tapFunc()
                    
                case .denied:
                    break
                   // self.recordingButton.isEnabled = false
                    print("Action Denied")
                    
                case .restricted:
                    break
                   // self.recordingButton.isEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    break
                   // self.recordingButton.isEnabled = false
                    print("Speech recognition not yet authorized")
                }
            }
        }
        
    }

    
    
    // ************************* Option Button Click Event ******************
    
    func buttonClicked(sender: UIButton)
    {
        
        let btnsendtag: UIButton = sender
        if(option_Count == 1)
        {
            var btncount = 0
            for btn: UIButton  in arrayOfOptionButton
            {
                
                btn.backgroundColor = UIColor.red
                IsSelected[btncount] = false
                btncount+=1
                
            }
            IsSelected[btnsendtag.tag - 1] = true
            btnsendtag.backgroundColor = UIColor.green
        }
            
        else
        {
            if (IsSelected[btnsendtag.tag - 1] == true)
            {
                IsSelected[btnsendtag.tag - 1] = false
                btnsendtag.backgroundColor = UIColor.red
            }
            else
            {
                IsSelected[btnsendtag.tag - 1] = true
                btnsendtag.backgroundColor = UIColor.green
            }
            
        }
    }
    
    // *************************On Submit Button s******************
    
    
    // *************************Question Fetch from Core Data******************
    func loadQuestion(QuestionId: Int)
    {
        IsOption = []
        IsSelected  = []
        arrayOfOptionButton  = []
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        var QuestionTag : String?
        let context = DatabaseController.persistentContainer.viewContext
        let question:Question_Master = NSEntityDescription.insertNewObject(forEntityName: "Question_Master", into: context) as! Question_Master
        //let QuestionId: Int = 5
        let fetchRequests:NSFetchRequest<Question_Master> = Question_Master.fetchRequest()
        let predicate = NSPredicate(format: "questionId == \(QuestionId)")
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequests)
            let QuestionsearchResults = (searchResults as NSArray).filtered(using: predicate)
            for mainresult in QuestionsearchResults as! [Question_Master]
            {
                let predicate = NSPredicate(format: "questionId == \(QuestionId)")
                do
                {
                    let Questionresult = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequests)
                    var searchResults = (Questionresult as NSArray).filtered(using: predicate)
                    if let questiontag = (mainresult.questionString)
                    {
                        lblQuestion.text = "\(questiontag)"
                        Audio(Input : "  Question number \(QuestionId) \(questiontag)")                                    //audio func called
                        
                        Audio(Input : "  Your Option are")                                    //audio func called
                    }
                }
                Points = Int(mainresult.points)
            }
            
        }
        catch let errors as NSError
        {
            print(errors)
        }
        
    // *************************Option Fetch From Core Data ******************
        
        let fetchRequestsoption:NSFetchRequest<Option_Master> = Option_Master.fetchRequest()
        //  let Optionpredicate = NSPredicate(format: "question_id == \(mainresult.questionId)")
        do {
            let OpsearchResults = try DatabaseController.getContext().fetch(fetchRequestsoption)
            var index: Int = 1
            var Optionindex: Int = 1
            let optionResults = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequestsoption)
            do
            {
                
                
                let Optionpredicate = NSPredicate(format: "question_id ==\(QuestionId)")
                let OptionsearchResults = (optionResults as NSArray).filtered(using: Optionpredicate)
                
                for oresult in OptionsearchResults as! [Option_Master]
                {
                    // print("\(oresult)")
                    optionCount()
    // ******************* Dynamic Button Create**************************
                    let frame1 = CGRect(x: 40, y: 0 + (index * 35), width: 200, height: 30 )
                    let button:UIButton = UIButton(frame: frame1)
                    button.tag = Int(oresult.option_id)
                    button.setTitle(oresult.options, for: .normal)
                    
                    button.titleLabel?.text = "\(oresult.options)"
                    optionno = Int(oresult.option_id)
                    
                    print(optionno)
                    
                    foutput = oresult.is_Option
                    print(foutput, "hello")
                    
                    Audio(Input : "  Option  \(oresult.option_id)! \(oresult.options!)")                                    //audio func called
                    
                    button.backgroundColor = UIColor.red
                    button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                    IsSelected.insert(false, at: Int(oresult.option_id - 1 ))
                    
                
                    
                    //var is_Options: Bool = oresult.is_Option
                    //self.arrayOfOptionButton.append(button)
                    self.arrayOfOptionButton.insert(button , at: Int(oresult.option_id-1 ))
                    self.IsOption.insert(oresult.is_Option, at: Int(oresult.option_id-1 ))
                    
                    //self.arrayOfOptionButton[oresult.option_id-1] = button
                    //self.IsOption[oresult.option_id-1] = oresult.is_Option
                    
                    
                    self.OptionScroll.addSubview(button)
                    
                    index+=1
                 }
            }

        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
        //*******************Project Path ***********************
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath)
    }
    
    // *************************Function for New Question Load ******************
    func onLoadClearItems()
    {
        arrayOfOptionButton.removeAll()
        IsOption.removeAll()
        IsSelected.removeAll()
        let subviews = self.OptionScroll.subviews
        for subview in subviews{
            subview.removeFromSuperview()
            audioEngine.stop()
        }
    }
    
    // *************************Alert Option ******************
    
    func showAlert(msg: String)
    {
        self.audioEngine.stop()
        let alert = UIAlertController(title: "Alert", message: "\(msg)", preferredStyle: UIAlertControllerStyle.alert)
        
        tapFunc()
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            action in self.loadQuestion(QuestionId: self.getQuestionId(ques: self.QuestionId))
              self.audioEngine.stop()
        }))
        self.present(alert, animated: true, completion: nil)
        Audio(Input : " \(msg)")                                    //audio func called
    }
    
    // *************************Question Count ******************
    func QuestionCount()
    {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = DatabaseController.persistentContainer.viewContext
        let question:Question_Master = NSEntityDescription.insertNewObject(forEntityName: "Question_Master", into: context) as! Question_Master
        let fetchRequests:NSFetchRequest<Question_Master> = Question_Master.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequests)
            for result in searchResults as! [Question_Master]
                {
                    count = searchResults.count - 1
                
                }
            print("question count : \(count)")
            }
            
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // *************************Option Count ******************
    
    func optionCount()
    {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = DatabaseController.persistentContainer.viewContext
        
        let fetchRequestsoption:NSFetchRequest<Option_Master> = Option_Master.fetchRequest()
        do {
            let OpsearchResults = try DatabaseController.getContext().fetch(fetchRequestsoption)
            let optionResults = try DatabaseController.persistentContainer.viewContext.fetch(fetchRequestsoption)
            do
            {
                let Optionpredicate = NSPredicate(format: "question_id == \(QuestionId) AND is_Option == %@", NSNumber(booleanLiteral: true))
                //let Optionpredicate = NSPredicate(format: "question_id == 11 AND is_Option == %@", NSNumber(booleanLiteral: true))
                let OptionsearchResults = (optionResults as NSArray).filtered(using: Optionpredicate)
                option_Count = OptionsearchResults.count
                print("option count \(option_Count)")
                print("hey", OptionsearchResults.count)
            }
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // *************************Increment Question ******************
    func getQuestionId(ques: Int) -> Int
    {
        if(QuestionId < count)
        {
            QuestionId = ques + 1
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "It's Last Question!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        return QuestionId
    }
    
    // *************************Skip Button Action ******************
    @IBAction func skipBtn(_ sender: Any)
    {
        audioEngine.stop()
        onLoadClearItems()
        speakTalk.stopSpeaking(at:AVSpeechBoundary.immediate)
        loadQuestion(QuestionId: self.getQuestionId(ques: self.QuestionId))
    }
    
    
    override public func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        speakTalk.stopSpeaking(at:AVSpeechBoundary.immediate)
    }
    
    //===================== Speech Recognition ============================//
    
    
    func startRecording() throws
    {
      //  print("Speak For Recording")
        
       
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
      
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        print("Recognition request")
        
        guard let inputNode = audioEngine.inputNode
            else
        {
            fatalError("Audio engine has no input node")
        }
        guard let recognitionRequest = recognitionRequest else
        {
            fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
        }
        
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
            if self.speak.contains("One") || self.speak.contains("1") || self.speak.contains("one")
            {
                 tag = 1
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                self.IsSelected[btnsendtag.tag - 1] = true
                btnsendtag.backgroundColor = .green
                self.optionsoundcatch = ""
                
            }
            
            if self.speak.contains("Two") || self.speak.contains("To") || self.speak.contains("Do")
            {
                tag = 2
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                self.IsSelected[btnsendtag.tag - 1] = true
                btnsendtag.backgroundColor = .green
                self.optionsoundcatch = ""
                
            }
            
            if self.speak.contains("Three") || self.speak.contains("three") || self.speak.contains("3")
            {
                tag = 3
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                self.IsSelected[btnsendtag.tag - 1] = true
                btnsendtag.backgroundColor = .green
                self.optionsoundcatch = ""
            }
             if self.speak.contains("Four") || self.speak.contains("For") || self.speak.contains("4")
            {
                tag = 4
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                self.IsSelected[btnsendtag.tag - 1] = true
                btnsendtag.backgroundColor = .green
                self.optionsoundcatch = ""
            }
            
            else if self.speak.contains("Skip") || self.speak.contains("Speed")
            {
                
                tag = 11
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                btnsendtag.sendActions(for: .touchUpInside)
                self.optionsoundcatch = ""
                
            }
            
            else if self.speak.contains("ok") || self.speak.contains("OK")
            {
                tag = 10
                let btnsendtag: UIButton = self.view.viewWithTag(tag) as! UIButton
                btnsendtag.sendActions(for: .touchUpInside)
                self.optionsoundcatch = ""
            }
             else if self.speak.contains("Back") || self.speak.contains("back")
             {
                tag = 13
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
                
             //   self.recordingButton.isEnabled = true
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
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
           // recordingButton.isEnabled = true
        } else {
           // recordingButton.isEnabled = false
        }
    }
    
    @IBAction func submitBtn(_ sender: Any)
    {
        speakTalk.stopSpeaking(at:AVSpeechBoundary.immediate)
        let btnsendtag: UIButton = sender as! UIButton
        var score: Int = Int(lblScore.text!)!
        var msg : String
        for selectedoption in IsSelected{
            print(selectedoption)
        }
        
        if IsSelected == IsOption
        {
            score = score + Points
            lblScore.text = "\(score)"
            Audio(Input : "Your have Selected, \(IsOption)")
            msg = "Right Answer . . . "
            Audio(Input : "  Your Score is . .  \(score)")
            showAlert(msg: msg)
            
        }else{
            msg = "Oops  Worng Answer"
            showAlert(msg: msg)
        }
        audioEngine.stop()
        optionsoundcatch = ""
       // print("\(optionsoundcatch), hiiii")
        onLoadClearItems()
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
