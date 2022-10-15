

import UIKit


final class SMSCodeVC: UIViewController {
    
    private let phoneTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .secondarySystemBackground
        view.placeholder = "Enter SMS Code"
        view.textAlignment = .center
        view.returnKeyType = .continue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(phoneTextField)
        phoneTextField.becomeFirstResponder()
        phoneTextField.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        phoneTextField.center = view.center
        phoneTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension SMSCodeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text,
           !text.isEmpty {
            AuthManager.shared.verifyCode(text) { [weak self] success in
                guard success else { return }
                DispatchQueue.main.async {
                    let vc = ToDoListAssembly.assembly()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
        }
        return true
    }
}
