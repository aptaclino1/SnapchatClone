//
//  CustomTextField.swift
//  SnapchatClone
//
//  Created by Messiah on 11/10/23.
//

import Foundation
import UIKit

class FloatingLabelTextField: UITextField {

    private let floatingLabel = UILabel()
    private let underLineView = UIView()

    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
            updateFloatingLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        floatingLabel.textColor = UIColor.lightGray
        floatingLabel.font = UIFont.systemFont(ofSize: 14.0)

        underLineView.backgroundColor = UIColor.black

        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16.0)

        addSubview(floatingLabel)
        addSubview(underLineView)

        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        underLineView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            floatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            floatingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            floatingLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -4.0),

            underLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underLineView.topAnchor.constraint(equalTo: bottomAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 1.0),
        ])

        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateFloatingLabel()
    }

    @objc private func textFieldDidChange() {
        updateFloatingLabel()
    }

    private func updateFloatingLabel() {
        let isTextFieldEmpty = text?.isEmpty ?? true
        floatingLabel.alpha = 1.0
        let transform = CGAffineTransform(translationX: 0, y: isTextFieldEmpty ? 0 : -20)
        floatingLabel.transform = transform
        attributedPlaceholder = NSAttributedString(
            string: isTextFieldEmpty ? "" : placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear]
        )
    }
}


