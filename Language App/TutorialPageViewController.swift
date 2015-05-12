//
//  TutorialPageViewController.swift
//  Ciao Game
//
//  Created by Clinton D'Annolfo on 12/05/2015.
//  Copyright (c) 2015 Clinton D'Annolfo. All rights reserved.
//

import Foundation

class TutorialPageViewController: TutorialItemViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = UIImage(named: ImageName.TutorialImages[index])
    }
}