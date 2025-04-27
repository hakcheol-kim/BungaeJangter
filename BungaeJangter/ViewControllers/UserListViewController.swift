//
//  UserListViewController.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit
enum UserType: String {
    case man = "male"
    case woman = "female"
}

class UserListViewModel {
    var type: UserType
    weak var collectionView: UICollectionView? = nil
    
    var pageKey: Int = 0
    var total: Int = 0
    var limit: Int = 30
    var isDataLoading: Bool = false
    var isEditing: Bool = false
    var deleteItemIds: [UserInfo] = []
    
    init(type: UserType) {
        self.type = type
    }
    
    var userList: [UserInfo] = []
    var listType: ListType = .list
    
    enum ListType {
        case list, square
    }

    enum Action {
        case dataRest
        case addList
        case requestUserList
        
        case checkedItem(Bool, UserInfo)
        case changeDeleteMode(Bool)
    }
    
    func send(_ action: Action) {
        switch action {
        case .dataRest:
            self.pageKey = 0
            send(.requestUserList)
            return
        case .addList:
            self.pageKey += limit
            if pageKey > total {
                return
            }
            send(.requestUserList)
            return
        case .requestUserList:
            AppDelegate.showLoading(true)
            isDataLoading = true
            let req: RequestModel.UserList = .init(skip: pageKey, gender: type.rawValue)
            Task {
                let response = try await ApiClient.request(.userList(req), decoder: UserResponse.self)
                await MainActor.run {
                    self.isDataLoading = false
                    switch response {
                    case .success(let result):
                        AppDelegate.showLoading(false)
                        self.total = result.total
                        self.limit = result.limit
                        
                        if self.pageKey == 0 {
                            self.userList.removeAll()
                        }
                        
                        if result.users.count > 0 {
                            //증복 유저 제거
                            let users = Array(Set(result.users))
                            self.userList.append(contentsOf: users)
                        }
                        self.pageKey = result.skip
                        self.collectionView?.reloadData()
                        break
                    case .failure(let error):
                        AppDelegate.showToast(error.localizedDescription)
                        break
                    }
                }
            }
            return
        case .checkedItem(let isCheck, let user):
            if isCheck {
                deleteItemIds.append(user)
            } else {
                if let index = deleteItemIds.firstIndex(where: { $0 == user }) {
                    deleteItemIds.remove(at: index)
                }
            }
        case .changeDeleteMode(let value):
            self.isEditing = value
            if value {
                self.deleteItemIds.removeAll()
            }
            else {
                if deleteItemIds.count > 0 {
                    var newList: [UserInfo] = []
                    for user in self.userList {
                        if deleteItemIds.contains(where: { $0 == user }) {
                            continue
                        }
                        newList.append(user)
                    }
                    self.userList = newList
                }
            }
            collectionView?.reloadData()
            return
        }
    }
    
}

class UserListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instantiate(type: UserType) -> UserListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController else {
            fatalError("❌ UserListViewController 인스턴스화 실패")
        }
        vc.viewModel = UserListViewModel(type: type)
        return vc
    }
    
    private var viewModel: UserListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.collectionView = collectionView
        collectionView.register(UINib(nibName: "UserListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "UserListCollectionCell")
        collectionView.register(UINib(nibName: "UserListHeaderReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserListHeaderReusableView.reuseIdentifier)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .accent
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        viewModel.send(.dataRest)
        setUpLayout()
    }
    func setUpLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            switch viewModel.listType {
            case .list:
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case .square:
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    @objc private func refresh() {
        viewModel.send(.dataRest)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
}

extension UserListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserListHeaderReusableView.reuseIdentifier, for: indexPath) as! UserListHeaderReusableView
            header.setData(totalCount: viewModel.total, listType: viewModel.listType, isEditing: viewModel.isEditing)
            header.onClickedActions = { [weak self] action in
                switch action {
                case .changeListType(let type):
                    self?.viewModel.listType = type
                    self?.setUpLayout()
                case .changeDelete(let toggle):
                    self?.viewModel.send(.changeDeleteMode(toggle))
                }
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserListCollectionCell", for: indexPath) as? UserListCollectionCell else {
            return UICollectionViewCell()
        }
        if indexPath.row < viewModel.userList.count {
            let data = viewModel.userList[indexPath.row]
            let isChecked = viewModel.deleteItemIds.contains(where: { $0 == data })
            cell.setData(data, listType: viewModel.listType, isEditing: viewModel.isEditing, isChecked: isChecked)
            cell.onClickActions = { [weak self] action in
                switch action {
                case .check(let check):
                    self?.viewModel.send(.checkedItem(check, data))
                }
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.listType {
        case .list:
            return CGSize(width: collectionView.frame.width, height: 90)
        case .square:
            let itemWidth: CGFloat = floor(collectionView.bounds.width/3.0)
            return CGSize(width: itemWidth, height: itemWidth * 1.3)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height >= scrollView.frame.size.height else {
            return
        }
        
        let contentsOffsetY = floor(scrollView.contentOffset.y * 100) / 100
        var contentsHeightY = floor((scrollView.contentSize.height - scrollView.frame.size.height) * 100) / 100
        
        if contentsHeightY < 0 {
            contentsHeightY = 1.0
        }
        
        if contentsOffsetY >= contentsHeightY, viewModel.pageKey < viewModel.total, viewModel.isDataLoading == false {
            viewModel.send(.addList)
        }
    }
}
