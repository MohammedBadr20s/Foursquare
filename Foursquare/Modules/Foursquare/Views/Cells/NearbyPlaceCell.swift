//
//  NearbyPlaceCell.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit
import Kingfisher

class NearbyPlaceCell: UITableViewCell {


    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    static let id = "NearbyPlaceCell"
    
    static func NearbyPlaceNib() -> UINib {
        return UINib(nibName: self.id, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(title: String, descriptionData: String) {
        self.titleLbl.text = title
        self.descriptionLbl.text = descriptionData
    }
    func getPhoto(imageURL: String?) {
        if let imageStringURL = imageURL {
            guard let url = URL(string: imageStringURL) else { return }
            
            self.placeImageView.kf.setImage(with: url, placeholder: UIImage(named: "fullImage"))
        } else {
            self.placeImageView.image = UIImage(named: "fullImage")
        }
    }
}
