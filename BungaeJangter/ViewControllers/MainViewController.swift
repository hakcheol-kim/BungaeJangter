//
//  MainViewController.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit

class MainViewController: UIViewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instantiateViewController() -> MainViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return vc
    }
    
    @IBOutlet weak var container: UIStackView!
    @IBOutlet weak var manButton: UnderLineButton!
    @IBOutlet weak var womanButton: UnderLineButton!

    
    private lazy var pageViewController: UIPageViewController = {
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pvc.dataSource = self
        pvc.delegate = self
        return pvc
    }()

    private let viewControllers: [UIViewController] = [
        UserListViewController.instantiate(type: .man),
        UserListViewController.instantiate(type: .woman)
    ]

    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bungae Jangter"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        let menu = UIButton(type: .system)
        menu.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        menu.tintColor = .accent
        menu.tag = 100
        menu.addTarget(self, action: #selector(onClickedNaviBarItem(_ :)), for: .touchUpInside)
        
        let leftItem = UIBarButtonItem(customView: menu)
        
        self.navigationItem.leftBarButtonItem = leftItem
        
        let setting = UIButton(type: .system)
        setting.setImage(UIImage(systemName: "gear"), for: .normal)
        setting.tintColor = .accent
        setting.tag = 200
        setting.addTarget(self, action: #selector(onClickedNaviBarItem(_ :)), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem(customView: setting)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    private func setupUI() {
        addChild(pageViewController)
        container.addArrangedSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
        updateButtonSelection()
    }
    
    private func moveToPage(index: Int) {
        guard index != currentIndex else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        currentIndex = index
        pageViewController.setViewControllers([viewControllers[index]], direction: direction, animated: true)
        
        updateButtonSelection()
    }
    
    private func updateButtonSelection() {
        manButton.isSelected = (currentIndex == 0)
        womanButton.isSelected = (currentIndex == 1)
    }
    
    @objc func onClickedNaviBarItem(_ sender: UIButton) {
        if sender.tag == 100 {
            print("left button clicked")
        }
        else if sender.tag == 200 {
            print("right button clicked")
        }
    }
    @IBAction func onClickedButtonActions(_ sender: UIButton) {
        if sender == manButton {
            moveToPage(index: 0)
        }
        else if sender == womanButton {
            moveToPage(index: 1)
        }
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else { return nil }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: visibleVC) {
            currentIndex = index
            updateButtonSelection()
        }
    }
}
