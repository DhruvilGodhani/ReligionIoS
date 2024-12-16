//
//  TableViewCell.swift
//  ReligiousAPI
//
//  Created by ADMIN on 13/12/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var religionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
