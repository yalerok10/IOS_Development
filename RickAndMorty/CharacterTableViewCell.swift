//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Валерия Самонина on 15.06.2020.
//  Copyright © 2020 Валерия Самонина. All rights reserved.
//

import UIKit
@IBDesignable
class CharacterTableViewCell: UITableViewCell {
   
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Episode: UILabel!
    @IBOutlet weak var lastKnownlocation: UILabel!
    @IBOutlet weak var firstSeenIn: UILabel!
    @IBOutlet weak var statusCircle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
