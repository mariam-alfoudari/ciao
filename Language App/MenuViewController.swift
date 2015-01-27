//
//  RootViewController.swift
//  Language App
//
//  Created by Clinton D'Annolfo on 7/12/2014.
//  Copyright (c) 2014 Clinton D'Annolfo. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class MenuViewController: UIViewController, SettingsDelegate {
    
    //MARK: Properties
    var managedObjectContext: NSManagedObjectContext? = nil
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: Outlets
    @IBOutlet var menuButtonCollection: [UIButton]!
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var gameModeButton: UIButton!
    @IBOutlet weak var grammarButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    //MARK: Delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in menuButtonCollection {
            //CALayer class properties
            button.layer.cornerRadius = CGFloat(6)
            button.layer.borderWidth = CGFloat(1)
            button.layer.borderColor = button.tintColor?.CGColor
            //UIColor.blueColor().CGColor
        }
        grammarButton.setTitle(userDefaults.stringForKey("language")! + " " + NSLocalizedString("Grammar",comment: "Show wikipedia grammar page button on menu"), forState: UIControlState.Normal)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Segue
    //Language Setting Delegate
    func returnToSource(vc: UIViewController, language: String) {
        grammarButton.setTitle(language + " " + NSLocalizedString("Grammar",comment: "Show wikipedia grammar page button on menu"), forState: UIControlState.Normal)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if self.managedObjectContext != nil {
            switch (segue.identifier!) {
                case "Show Grammar":
                    let destinationViewController = segue.destinationViewController as GrammarViewController
                    let dataPlistPath: String = NSBundle.mainBundle().pathForResource("WikipediaGrammarURL", ofType:"strings")!
                    let dataPlistDictionary = NSDictionary(contentsOfFile: dataPlistPath)!
                    if let url = NSURL(string: dataPlistDictionary.valueForKey(userDefaults.stringForKey("language")!) as String) {
                        let urlRequest = NSURLRequest(URL: url)
                        destinationViewController.urlRequest = urlRequest
                    }
                    //destinationViewController.webView?.loadRequest(urlRequest)
                case "Show Game":
                    let destinationViewController = segue.destinationViewController as GameViewController
                    destinationViewController.managedObjectContext = self.managedObjectContext
                    println(destinationViewController.description)
                case "Show Statistics":
                    let destinationViewController = segue.destinationViewController as StatisticsViewController
                    destinationViewController.managedObjectContext = self.managedObjectContext
                    println(destinationViewController.description)
                case "Show Settings":
                    let navController = segue.destinationViewController as UINavigationController
                    let destinationViewController = navController.topViewController as SettingsViewController
                    destinationViewController.delegate = self
//                    destinationViewController.managedObjectContext = self.managedObjectContext
                    println(destinationViewController.description)
                
            default:
                println("prepareForSegue: no segue logic on \(segue.identifier)")
            }
//        }
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        super.performSegueWithIdentifier(identifier, sender: sender)
    }

    /*@IBAction func clickSettings(sender: UIButton) {
        self.presentViewController(SettingsController(), animated: true, completion: nil)
    }*/
    
    //func pushViewController(viewController: UIViewController, animated: Bool) {
        
    //}
}