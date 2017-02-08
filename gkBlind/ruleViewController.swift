//
//  ruleViewController.swift
//  gkBlind
//
//  Created by CG-3 on 01/02/17.
//  Copyright © 2017 CG-3. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Speech
import AVFoundation

class ruleViewController: UIViewController
{
    let speakTalk = AVSpeechSynthesizer()
    var speakText = AVSpeechUtterance()
    
    func Audio(Input : String)
    {
         speakText = AVSpeechUtterance(string: "\(Input)")
        speakText.rate = 0.4
        speakText.pitchMultiplier = 1.72
        speakTalk.speak(speakText)
        
        
    }

    
    @IBOutlet weak var ruleText: UITextView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        var speech: String = "GENERAL RULES."
        
        var rule : String = "Only team entries are eligible. " +
        "A team shall consist of max two persons. " +
        "The decision of the quiz-master will be final and will not be subjected to any change." +
        "The participants shall not be allowed to  use mobile or other electronic instruments." +
        "The questions shall be in the form of multiple choice, True / False statement, Specific-answer question etc." +
        "Audience  shall  not give any hints or clues to the competitors."
        
        ruleText.text = "\(speech)\n \(rule)"
        
        var text1 = speech.replacingOccurrences(of: ".", with: " . . . ")
        var text2 = rule.replacingOccurrences(of: ".", with: " . . . ")

        Audio(Input : "\(text1)\n \(text2)")
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        speakTalk.stopSpeaking(at:AVSpeechBoundary.immediate)
    }

}
