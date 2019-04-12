//
//  Model.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 16/01/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import UIKit


/*
 <NumCode>036</NumCode>
 <CharCode>AUD</CharCode>
 <Nominal>1</Nominal>
 <Name>Австралийский доллар</Name>
 <Value>16,0102</Value>
*/
class Currency {
    
    var NumCode: String?
    var CharCode: String?
    
    var Nominal: String?
    var nominalDouble: Double?
    
    var Name: String?
    
    var Value: String?
    var valueDouble: Double?
    
    var imageFlag: UIImage? {
        if let pathToImage = Bundle.main.path(forResource: CharCode, ofType: "png", inDirectory: "flagsImages") {
            return UIImage(named: pathToImage)
        }
        return nil
    }
    
    class func rouble() -> Currency {
        let rub = Currency()
        
        rub.Name = "Российский рубль"
        rub.CharCode = "RUR"
        rub.Nominal = "1"
        rub.nominalDouble = 1
        rub.Value = "1"
        rub.valueDouble = 1
        
        return rub
    }
}



class Model: NSObject {
    
    static let sharedInstance = Model()
    
    
    var currencies: [Currency] = []
    var currentDate: String = "12.12.2013" // from topical XML file
    
    var currentCurrency: Currency?
    var currentCharacters: String = ""
    
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    //  Currency conversion function
    func convert(amount: Double?) -> String {
        if (amount == nil) {
            return ""
        }
        
        let d = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!)) * amount!
        
        let formatter = MyCurrencyFormatter()
        return formatter.toFormatDecimalValueAsString(d as NSNumber, currencySymbolUsed: false)!
    }
    
    
    //  Path to XML (bundle or existing in directory)
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"

        print(path)
        
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    
    var urlForXML: URL? {
        return URL(fileURLWithPath: pathForXML)
    }
    
    
    //  Loading XML from cbr.ru and saving it in the application catalog
    //  http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002
    func loadXMLFile (date: Date?) {
        //  Firstly we have URL by default without date (from 2002 year)
        var urlWithoutDate = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil {
            urlWithoutDate += MySimpleDateFormatter().fromDateToString(date: date!)
        }
        
        let url = URL(string: urlWithoutDate)
        

        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            
            var errorLoading: String?
            
            //  if data was loaded
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/data.xml"
                
                let urlForSave = URL(fileURLWithPath: path)
                
                //  attempt to save loaded "data" to file by "urlForSave"
                do {
                    try data?.write(to: urlForSave)
                    print("Файл загружен")
                    self.parseXML() //  Parse data in success case
                } catch {
                    print("Error when save data within loadXMLFile: " + error.localizedDescription)
                    
                    errorLoading = error.localizedDescription
                }
            } else {
                print("Error within loadXMLFile: " + error!.localizedDescription)
                
                errorLoading = error!.localizedDescription
            }
            
            //  if data wasn't loaded
            if let errorLoading = errorLoading {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorWhileXMLLoading"), object: self, userInfo: ["ErrorDescription":errorLoading])
            }
        
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)

        task.resume()
    }
    
    
    //  Parsing XML and putting it in the curriensies: [Currency].
    //  Then sending notification to the application that the data has been updated
    func parseXML() {
        currencies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXML!)
        
        parser?.delegate = self
        parser?.parse()
        
        for currency in currencies {
            if currency.CharCode == fromCurrency.CharCode {
                fromCurrency = currency
            }
            
            if currency.CharCode == toCurrency.CharCode {
                toCurrency = currency
            }
        }
        
        print("Данные обновлены")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
    }
}



extension Model: XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        //  Parsing date
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                self.currentDate = currentDateString
            }
        }
        
        //  Initialize new currency. Below new currency will be filled
        if elementName == "Valute" {
            self.currentCurrency = Currency()
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentCharacters = string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "NumCode" {
            self.currentCurrency?.NumCode = currentCharacters
        }
        if elementName == "CharCode" {
            self.currentCurrency?.CharCode = currentCharacters
        }
        if elementName == "Nominal" {
            self.currentCurrency?.Nominal = currentCharacters
            self.currentCurrency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name" {
            self.currentCurrency?.Name = currentCharacters
        }
        if elementName == "Value" {
            self.currentCurrency?.Value = currentCharacters
            self.currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        //  Adding filled currecy
        if elementName == "Valute" {
            self.currencies.append(currentCurrency!)
        }
    }
}
