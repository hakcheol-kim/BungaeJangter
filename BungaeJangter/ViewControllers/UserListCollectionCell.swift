//
//  UserListCollectionCell.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit
import Kingfisher
class UserListCollectionCell: UICollectionViewCell {
    enum Action {
        case check(Bool)
    }
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkBoxButtton: UIButton!
    
    var isEditing: Bool = false
    var isChecked: Bool = false
    var onClickActions:((_ action: UserListCollectionCell.Action) ->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ userInfo: UserInfo, listType: UserListViewModel.ListType, isEditing: Bool, isChecked: Bool) {
        self.isEditing = isEditing
        self.isChecked = isChecked
        checkBoxButtton.isHidden = true
        
        if isEditing {
            checkBoxButtton.isHidden = false
            checkBoxButtton.isSelected = isChecked
        }
        
        if listType == .list {
            containerView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            containerView.axis = .horizontal
            nameLabel.textAlignment = .left
            descptionLabel.textAlignment = .left
            addressLabel.textAlignment = .left
        }
        else {
            containerView.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
            containerView.axis = .vertical
            nameLabel.textAlignment = .center
            descptionLabel.textAlignment = .center
            addressLabel.textAlignment = .center
        }
        profileImageView.setImage(userInfo.image, placeholder: UIImage(systemName: "person.circle"))
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.systemGray.cgColor
        profileImageView.layer.borderWidth = 1
        
        nameLabel.text = userInfo.username
        descptionLabel.text = "\(userInfo.age) age, \(userInfo.height)(cm)"
        addressLabel.isHidden = true
        if let address = userInfo.address {
            addressLabel.isHidden = false
            addressLabel.text = address.address
        }
    }
    @IBAction func onClickedButtonActions(_ sender: UIButton) {
        if sender == checkBoxButtton {
            self.isChecked.toggle()
            sender.isSelected = isChecked
            self.onClickActions?(.check(isChecked))
        }
    }
    
    
}
