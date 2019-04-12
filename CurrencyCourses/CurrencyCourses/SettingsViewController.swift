//
//  SettingsViewController.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 17/01/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func pushCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushShowCources(_ sender: Any) {
        Model.sharedInstance.loadXMLFile(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date = MySimpleDateFormatter().fromStringToDate(date: Model.sharedInstance.currentDate)!
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
