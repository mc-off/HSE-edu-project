

import UIKit

final class ToDoListCell: UITableViewCell {
    
    static let id = "ToDoListCell"
    
    var model: ToDoListItem? {
        didSet {
            titleLabel.text = model?.title
            descLabel.text = model?.description
            if let image = UIImage(systemName: model?.imageName ?? "") {
                leftImageView.image = image
            }
            switch model?.priority {
            case .low:
                priorityView.backgroundColor = .green
            case .normal:
                priorityView.backgroundColor = .yellow
            case .high:
                priorityView.backgroundColor = .red
            default:
                break
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var leftImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "gear")
        return image
    }()
    
    private lazy var priorityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
               titleLabel,
               descLabel
            ]
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                leftImageView,
                vStackView,
                priorityView
            ]
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private func setupUI() {
        addSubview(hStackView)
        hStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        hStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        hStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        leftImageView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        priorityView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
