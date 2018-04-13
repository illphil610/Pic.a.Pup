//
//  CardContentViewController.swift
//  Pic.a.Pup
//
//  Created by Philip on 4/8/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit

class CardContentViewController: UIViewController {
    
    @IBOutlet weak var breedInfoLabel: UILabel!
    @IBOutlet weak var breedNameLabel: UILabel!
    
    var breedNameSent = ""
    var breedInfoDetails = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        breedInfoLabel.text = breedInfoDetails
        breedNameLabel.text = breedNameSent

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
