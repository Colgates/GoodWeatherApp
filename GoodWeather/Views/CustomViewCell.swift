//
//  CustomViewCell.swift
//  GoodWeather
//
//  Created by Evgenii Kolgin on 02.11.2020.
//

import UIKit

class CustomViewCell: UITableViewCell {

    static let identifier = "customCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomViewCell", bundle: nil)
    }
    
    
    @IBOutlet weak var customCellImageView: UIImageView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
