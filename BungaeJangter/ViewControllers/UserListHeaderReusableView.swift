//
//  UserListHeaderReusableView.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit

class UserListHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var listTypeButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!
    var listType: UserListViewModel.ListType = .list
    static let reuseIdentifier = "UserListHeaderReusableView"
    
    var onClickedActions:((_ listType: UserListViewModel.ListType) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setData(totalCount: Int, listType: UserListViewModel.ListType) {
        self.listType = listType
        totalCountLabel.text = "Total: \(totalCount)"
    }
    
    @IBAction func onClickedActions(_ sender: UIButton) {
        if sender == listTypeButton {
            if listType == .list {
                self.listType = .square
                listTypeButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
            }
            else {
                self.listType = .list
                listTypeButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            }
            self.onClickedActions?(listType)
        }
    }
}
