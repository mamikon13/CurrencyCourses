//
//  CourceCell.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 10/03/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import UIKit

class CourceCell: UITableViewCell {

    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelCource: UILabel!
    
    func initCell(currency: Currency) {
        
        imageFlag.image = currency.imageFlag
        labelCurrencyName.text = currency.Name
        
        let formatter = MyCurrencyFormatter()
        labelCource.text = formatter.toFormatDecimalValueAsString(currency.valueDouble! as NSNumber, currencySymbolUsed: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
