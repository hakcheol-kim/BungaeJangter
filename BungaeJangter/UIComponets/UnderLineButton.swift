//
//  UnderLineButton.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit

class UnderLineButton: UIButton {
    private let lineView = UIView()
    var normalUnderlineColor: UIColor = .lightGray
    var selectedUnderlineColor: UIColor = .accent
    
    private var lineHeight: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUnderline()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUnderline()
    }
    
    private func setupUnderline() {
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: lineHeight),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        updateUnderlineColor()
    }
    
    private func updateUnderlineColor() {
        lineView.backgroundColor = isSelected ? selectedUnderlineColor : normalUnderlineColor
    }
    
    override var isSelected: Bool {
        didSet {
            updateUnderlineColor()
        }
    }
}
