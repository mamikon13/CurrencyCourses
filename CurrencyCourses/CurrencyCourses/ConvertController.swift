//
//  ConvertController.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 27/02/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import UIKit



class ConvertController: UIViewController {

    ///
    /// Here we have two "type" of target: From & To
    ///
    
    @IBOutlet weak var fromCurrenciesPicker: UIPickerView!
    @IBOutlet weak var toCurrenciesPicker: UIPickerView!
    
    @IBOutlet weak var fromAmount: UITextField!
    @IBOutlet weak var toAmount: UITextField!
    
    @IBAction func textFromEditingChanged(_ sender: Any) {
        let amount = Double(fromAmount.text!)
        toAmount.text = Model.sharedInstance.convert(amount: amount)
    }
    
    @IBOutlet weak var fromCharCode: UILabel!
    @IBOutlet var fromImage: UIImageView!
    @IBOutlet weak var toCharCode: UILabel!
    @IBOutlet var toImage: UIImageView!
    
    @IBOutlet weak var currentDate: UILabel!
    
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBAction func pushButtonDone(_ sender: Any) {
        fromAmount.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromAmount.text = "1"
        fromAmount.delegate = self
        
        fromCurrenciesPicker.delegate = self
        fromCurrenciesPicker.dataSource = self
        
        toCurrenciesPicker.delegate = self
        toCurrenciesPicker.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //  if data did refresh im Model in parseXML()
        fromCurrenciesPicker.reloadAllComponents()
        toCurrenciesPicker.reloadAllComponents()
        
        //  call a didSelect delegate's method of UIPickerView directly
        pickerView(fromCurrenciesPicker, didSelectRow: fromCurrenciesPicker.selectedRow(inComponent: 0), inComponent: 0)
        pickerView(toCurrenciesPicker, didSelectRow: toCurrenciesPicker.selectedRow(inComponent: 0), inComponent: 0)
        
        currentDate.text = Model.sharedInstance.currentDate
        navigationItem.rightBarButtonItem = nil
        
        fromCharCode.text = Model.sharedInstance.fromCurrency.CharCode
        toCharCode.text = Model.sharedInstance.toCurrency.CharCode

        fromImage.image = Model.sharedInstance.fromCurrency.imageFlag
        toImage.image = Model.sharedInstance.toCurrency.imageFlag

        textFromEditingChanged(self)
        
    }
    
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromAmount.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}



extension ConvertController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.sharedInstance.currencies.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.sharedInstance.currencies[row].Name
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            Model.sharedInstance.fromCurrency = Model.sharedInstance.currencies[row]
            fromCharCode.text = Model.sharedInstance.fromCurrency.CharCode
            fromImage.image = Model.sharedInstance.fromCurrency.imageFlag
        } else {
            Model.sharedInstance.toCurrency = Model.sharedInstance.currencies[row]
            toCharCode.text = Model.sharedInstance.toCurrency.CharCode
            toImage.image = Model.sharedInstance.toCurrency.imageFlag
        }
        
        textFromEditingChanged(self)
    }
    
}



extension ConvertController: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
    
}
