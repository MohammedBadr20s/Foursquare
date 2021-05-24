//
//  StateView.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit
enum State {
    case loading
    case error
    case noData
}
class StateView: UIView {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    var tryAgainAction: (() -> Void)? = nil
    let NibName = "StateView"
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        //        config()
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: NibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func config(status: State, msg: String? = nil, showTryAgain: Bool = false) {
        if let msg = msg {
            self.msgLbl.isHidden = false
            self.msgLbl.text = msg
        } else {
            self.msgLbl.isHidden = true
        }
        self.tryAgainBtn.isHidden = !showTryAgain
        switch status {
        case .loading:
            self.activityIndicator.startAnimating()
            self.stateImageView.isHidden = true
        case .noData:
            self.stateImageView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.stateImageView.image = UIImage(named: "noData")
        case .error:
            self.stateImageView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.stateImageView.image = UIImage(named: "error")
            
        }
    }
}
