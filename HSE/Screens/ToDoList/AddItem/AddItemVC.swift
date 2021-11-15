//
//  AddItemVC.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 02.11.2021.
//

import UIKit

final class AddItemVC: UIViewController {
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descLabel,
            hStackView
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            priorityButton,
            sendButton
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 16
        stack.backgroundColor = .yellow
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UITextField = {
        let label = UITextField()
        label.borderStyle = .line
        label.placeholder = "Введите название задачи"
        label.backgroundColor = .green
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descLabel: UITextField = {
        let label = UITextField()
        label.borderStyle = .line
        label.placeholder = "Введите описание задачи"
        label.backgroundColor = .red
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
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .systemBackground
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
        view.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            vStackView.topAnchor.constraint(equalTo: view.topAnchor),
            vStackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        bottomLayoutConstraint = vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomLayoutConstraint?.isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc
    private func sendBtnPressed() {
        let item = ToDoListItem(
            title: titleLabel.text ?? "Без названия",
            description: descLabel.text ?? "Без описания",
            imageName: "",
            priority: type ?? .normal
        )
        callback(item)
    }
    
    @objc
    private func openDropDownView() {
        
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
