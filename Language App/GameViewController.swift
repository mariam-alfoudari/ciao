//
//  ViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 6/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import iAd

class GameViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var gameButton1: UIButton!
    @IBOutlet weak var gameButton2: UIButton!
    @IBOutlet weak var gameButton3: UIButton!
    @IBOutlet weak var gameButton4: UIButton!
    @IBOutlet var gameButtonCollection: [GameButton]!
    @IBOutlet weak var soundButton: UIBarButtonItem!
    
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext? = nil
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var currentLanguageAttempts: Int
    var language = NSMutableDictionary(dictionary: NSUserDefaults.standardUserDefaults().dictionaryForKey(NSUserDefaults.standardUserDefaults().stringForKey("language")!)!)
    var languageAttempts = NSMutableDictionary(dictionary: NSUserDefaults.standardUserDefaults().dictionaryForKey("languageAttempts")!)
    var attempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("attempts")
    var correctAttempts: Int = NSUserDefaults.standardUserDefaults().integerForKey("correctAttempts")
    var streak: Int = 0
    var streakText: String {
        return NSLocalizedString("Streak: \(self.streak)", comment: "Navigation bar title showing the user's streak.")
    }
    var speakingSpeed: Float = NSUserDefaults.standardUserDefaults().floatForKey("speakingSpeed")
    var wordNumbers: [Int] = [0,0,0,0]
    var foreignWords: [Word] = []
    
    //MARK: Initialisers
    override init() {
        self.currentLanguageAttempts = self.language.valueForKey("attempts") as Int
//        self.currentLanguageAttempts = self.languageAttempts.valueForKey(self.userDefaults.stringForKey("language")!) as Int
        super.init()
    }
    
    required init(coder: NSCoder) {
        self.currentLanguageAttempts = self.language.valueForKey("attempts") as Int
//        self.currentLanguageAttempts = self.languageAttempts.valueForKey(self.userDefaults.stringForKey("language")!) as Int
        super.init(coder: coder)
    }
    
    deinit {
        saveUserDefaultLongestStreak()
        language.setValue(currentLanguageAttempts, forKey: "attempts")
        userDefaults.setInteger(self.attempts, forKey: "attempts")
        userDefaults.setInteger(self.correctAttempts, forKey: "correctAttempts")
        userDefaults.setObject(language, forKey: userDefaults.stringForKey("language")!)
        //(self.currentLanguageAttempts, forKey: self.userDefaults.stringForKey("language")!)
        userDefaults.setObject(self.languageAttempts, forKey: "languageAttempts")
        var error: NSErrorPointer = NSErrorPointer()
        if (managedObjectContext?.save(error) == nil) {
            println("Error: \(error.debugDescription)")
        } else {
            println("Managed Object Context save successful on GameViewController deinit")
        }
    }
    
    //MARK: View controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for gameButton in gameButtonCollection {
            gameButton.layer.cornerRadius = CGFloat(2)
        }
        if (self.userDefaults.boolForKey("hasSound") == true) {
            soundButton.title = "Sound On"
        } else {
            soundButton.title = "Sound Off"
        }
        var fetchRequest = NSFetchRequest()
        var entity: NSEntityDescription = NSEntityDescription.entityForName("Word", inManagedObjectContext: self.managedObjectContext!)!
        var predicate = NSPredicate(format: "language = %@", userDefaults.stringForKey("language")!)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        var error: NSErrorPointer = NSErrorPointer()
        self.foreignWords = managedObjectContext?.executeFetchRequest(fetchRequest, error: error) as [Word]
//        var adView: ADBannerView = ADBannerView(adType: ADAdType.Banner)
//        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait
//        self.view.addSubview(adView)
        //adView

        //let layoutConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[button]-30-[button2]", options: NSLayoutFormatOptions, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>)
        //button.addConstraint(<#constraint: NSLayoutConstraint#>)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Game methods
    @IBAction func clickSoundButton(sender: UIBarButtonItem) {
        if (self.userDefaults.boolForKey("hasSound") == true) {
            self.userDefaults.setBool(false, forKey: "hasSound")
            sender.title = "Sound Off"
        } else {
            self.userDefaults.setBool(true, forKey: "hasSound")
            sender.title = "Sound On"
        }
    }
    
    @IBAction func clickGameButton(sender: GameButton) {
        self.attempts += 1
        self.currentLanguageAttempts += 1
        //create a new NSNumber to increment itself
        var number: NSNumber
        if wordNumbers != [0,0,0,0] {
            number = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].attempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].attempts = number
        }
        if (sender.correct) {
            sayWord(wordLabel.text!, answer: sender.currentTitle!)
            if wordNumbers != [0,0,0,0] {
                number = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts.intValue + 1)
                foreignWords[wordNumbers[sender.gameButtonIndex]].correctAttempts = number
            }
            self.streak += 1
            self.correctAttempts += 1
            refreshGame()
        } else {
            UIView.animateWithDuration(0.25, animations: {sender.alpha = 0.25})
            number = NSNumber(int: foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts.intValue + 1)
            foreignWords[wordNumbers[sender.gameButtonIndex]].incorrectAttempts = number
            endStreak()
        }
    }

    func refreshGame () {
        var index = 0
        do {
            wordNumbers[index] = Int(arc4random_uniform(UInt32(self.foreignWords.count)))
            if (index == 0) {
                index += 1
            } else if (!contains(wordNumbers[0...(index-1)], wordNumbers[index])) {
                index += 1
            }
        } while (index < 4)
        let correctButtonIndex = Int(arc4random_uniform(4))
        for gameButton in gameButtonCollection {
            if gameButton.gameButtonIndex == correctButtonIndex {
                gameButton.correct = true
                gameButton.setTitle(foreignWords[wordNumbers[gameButton.gameButtonIndex]].englishWord.word, forState: UIControlState.Normal)
                wordLabel.text = foreignWords[wordNumbers[gameButton.gameButtonIndex]].word
                //wordLabel.text = answers[wordNumbers[gameButton.gameButtonIndex]]
            } else {
                gameButton.correct = false
                gameButton.setTitle(foreignWords[wordNumbers[gameButton.gameButtonIndex]].englishWord.word, forState: UIControlState.Normal)
            }
            UIView.animateWithDuration(0.25, animations: {gameButton.alpha = 1})
        }
        self.navigationItem.title = streakText
    }
    
    private func saveUserDefaultLongestStreak () {
        if userDefaults.integerForKey("longestStreak") < streak {
            userDefaults.setInteger(streak, forKey: "longestStreak")
        }
    }
    
    internal func endStreak () {
        saveUserDefaultLongestStreak()
        self.streak = 0
        self.navigationItem.title = streakText
    }
    
    func sayWord (word: String, answer: String) {
        if self.userDefaults.boolForKey("hasSound") {
            let dataPlistPath: String = NSBundle.mainBundle().pathForResource("IETFLanguageCode", ofType:"strings")!
            let dataPlistDictionary = NSDictionary(contentsOfFile: dataPlistPath)!

            var utteranceAnswer = AVSpeechUtterance(string: answer)
            var utteranceWord = AVSpeechUtterance(string: word)
            //utteranceAnswer.voice = AVSpeechSynthesisVoice(language: "en-AU")
            utteranceAnswer.rate = self.speakingSpeed

            if let languageCode = dataPlistDictionary.valueForKey(userDefaults.stringForKey("language")!) as? String {
                utteranceWord.voice = AVSpeechSynthesisVoice(language: languageCode)
            }
            utteranceWord.rate = self.speakingSpeed
            var synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utteranceAnswer)
            synthesizer.speakUtterance(utteranceWord)
        }
    }
}

