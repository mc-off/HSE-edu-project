//
//  AddItemVC.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 02.11.2021.
//

import UIKit

final class AddItemVC: UIViewController {
    
    private lazy var blurredView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = CustomVisualEffectView(blurEffect, intensity: 0.2)
        customBlurEffectView.frame = self.view.bounds
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.6)
        dimmedView.frame = self.view.bounds
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descLabel,
            hStackView
        ])
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemBackground
        stack.clipsToBounds = true
        stack.layer.cornerRadius = 16
        stack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            priorityButton,
            sendButton
        ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isScrollEnabled = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var descLabel: UITextView = {
        let label = UITextView()
        label.isScrollEnabled = false
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priorityButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "tag.circle"),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(openDropDownView),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var priorityDropDownView: DropDownView = {
        let view = DropDownView()
        view.delegate = self
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "arrow.up.circle"),
            for: .normal
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(sendBtnPressed),
            for: .touchUpInside
        )
        return button
    }()
    
    private var bottomLayoutConstraint: NSLayoutConstraint?
    private var type: ToDoListItem.ItemPriority?
    
    private let callback: (ToDoListItem) -> Void
    
    init(_ callback: @escaping (ToDoListItem) -> Void) {
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.becomeFirstResponder()
        setupUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIApplication.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIApplication.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissTap)
        )
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = .clear
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
        view.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            vStackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        bottomLayoutConstraint = vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomLayoutConstraint?.isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.placeholder = "напр., Читать главу книги каждый день в 20:30"
        descLabel.placeholder = "Описание"
    }
    
    @objc
    private func sendBtnPressed() {
        let item = ToDoListItem(
            title: titleLabel.text ?? "Без названия",
            description: descLabel.text ?? "Без описания",
            imageName: "",
            priority: type ?? .normal
        )
        dismiss(animated: true)
        //callback(item)
    }
    
    @objc
    private func openDropDownView() {
        if priorityDropDownView.superview == nil {
            view.addSubview(priorityDropDownView)
            priorityDropDownView.frame = CGRect(
                x: vStackView.frame.width/4,
                y: vStackView.frame.origin.y - 166,
                width: 250,
                height: 140
            )
        }
    }
    
    @objc
    private func dismissTap() {
        dismiss(animated: true)
    }
}

extension AddItemVC: DropDownViewDelegate {
    func didSelect(_ type: ToDoListItem.ItemPriority) {
        self.type = type
    }
}

private extension AddItemVC {
    private func setButtonConstraint(offset: CGFloat) {
        if let constraint = bottomLayoutConstraint {
            view.removeConstraint(constraint)
        }
        bottomLayoutConstraint = vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offset)
        bottomLayoutConstraint?.isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        setButtonConstraint(offset: keyboardSize.height)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        setButtonConstraint(offset: 0)
        view.layoutIfNeeded()
    }
}
