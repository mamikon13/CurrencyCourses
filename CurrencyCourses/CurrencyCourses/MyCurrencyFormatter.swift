//
//  MyCurrencyFormatter.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 24/03/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import Foundation



class MyCurrencyFormatter: NumberFormatter {
    
    let currencyFormatter: NumberFormatter
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init() {
        self.currencyFormatter = NumberFormatter()
        super.init()

        self.currencyFormatter.minimumFractionDigits = 0
        self.currencyFormatter.maximumFractionDigits = 2
        self.currencyFormatter.currencySymbol = "₽ "
    }
    
    
    func toFormatDecimalValueAsString(_ value: NSNumber, currencySymbolUsed: Bool) -> String? {
        self.currencyFormatter.numberStyle = currencySymbolUsed ? .currency : .decimal
        
        return self.currencyFormatter.string(from: value)!
    }
}
