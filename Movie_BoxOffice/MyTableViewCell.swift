//
//  MyTableViewCell.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/05/21.
//

import UIKit


class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var Movie_btn: UIButton!
    @IBOutlet weak var MovieRank: UILabel!
    @IBOutlet weak var MovieSacc: UILabel!
    @IBOutlet weak var OpenDt: UILabel!
    @IBOutlet weak var Moviename: UILabel!
    @IBOutlet weak var MovieCnt: UILabel!
    @IBOutlet weak var MovieAcc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
