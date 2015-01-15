//
//  StatisticsViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 20/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var favouriteLanguage: UILabel!
    @IBOutlet weak var wordsAttemptedLabel: UILabel!
    @IBOutlet weak var percentageCorrectLabel: UILabel!
    @IBOutlet weak var favouriteLanguageLabel: UILabel!
    @IBOutlet weak var successfulWordLabel: UILabel!
    @IBOutlet weak var unsuccessfulWordLabel: UILabel!
    @IBOutlet weak var longestStreakLabel: UILabel!
    
    //MARK: Properties
    var userDefaults = NSUserDefaults.standardUserDefaults()

    //MARK: Initialisers
    override init() {
        super.init()
    }
    
    required init (coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refresh() {
        var numberFormatter = NSNumberFormatter()
        //numberFormatter
        var streak = String(userDefaults.integerForKey("longestStreak"))
        var attempts = userDefaults.integerForKey("attempts")
        var correctAttempts = userDefaults.integerForKey("correctAttempts")
        var percentageCorrect: Double
        if attempts == 0 {
            percentageCorrect = 0
        } else {
            percentageCorrect = Double(correctAttempts)/Double(attempts) * 100
        }
        self.wordsAttemptedLabel.text = NSLocalizedString("Words Attempted: \(attempts)", comment: "Statistic label showing the number of words the user has attempted")
        self.percentageCorrectLabel.text = NSLocalizedString("Correct Ratio: \(ceil(percentageCorrect))%", comment: "Statistic label showing user's ratio of correct word attempts")
        self.favouriteLanguage.text = NSLocalizedString("Favourite Language: Italian mate!", comment: "User's favourite language")
        self.longestStreakLabel.text = NSLocalizedString("Longest Streak: \(streak)", comment: "Statistic label showing the user's longest streak")
    }
    
    override func viewWillAppear(animated: Bool) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Statistics methods
    @IBAction func ResetStats(sender: UIButton) {
        userDefaults.setInteger(0, forKey: "attempts")
        userDefaults.setInteger(0, forKey: "correctAttempts")
        userDefaults.setInteger(0, forKey: "longestStreak")
        refresh()
//        var storyBoard: UIStoryboard = UIStoryboard(name: "SecretStoryboard", bundle: NSBundle(path: "/Users/clintondannolfo/Desktop/Language App/Language App/SecretStoryboard.storyboard"))
//        var initialViewController: UIViewController = storyBoard.instantiateInitialViewController() as UIViewController
//        self.presentViewController(initialViewController, animated: true, completion: nil)
    }
}