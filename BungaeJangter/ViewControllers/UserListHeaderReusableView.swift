//
//  UserListHeaderReusableView.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit


class UserListHeaderReusableView: UICollectionReusableView {
    enum Action {
        case changeDelete(Bool)
        case changeListType(UserListViewModel.ListType)
    }
    @IBOutlet weak var listTypeButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var listType: UserListViewModel.ListType = .list
    var isEditing: Bool = false
    static let reuseIdentifier = "UserListHeaderReusableView"
    
    var onClickedActions:((_ action: UserListHeaderReusableView.Action) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setData(totalCount: Int, listType: UserListViewModel.ListType, isEditing: Bool) {
        self.listType = listType
        self.isEditing = isEditing
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
            self.onClickedActions?(.changeListType(listType))
        }
        else if sender == deleteButton {
            self.isEditing.toggle()
            if isEditing {
                deleteButton.setTitle("완료", for: .normal)
            }
            else {
                deleteButton.setTitle("삭제", for: .normal)
            }
            self.onClickedActions?(.changeDelete(isEditing))
        }
    }
}
