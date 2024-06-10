

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var myPhozullsCollectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameAndSurnameLabel: UITextView!
    @IBOutlet weak var usernameLabel: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    let profileVM = ProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
        configureNavBar()
        configCollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileVM.fetchMyPhozulls { err in
            if err != nil {
                self.presentAlert(title: "HATA", message: err!.localizedDescription)
            }
        }
        
        profileVM.fetchMyProfileInfos { err in
            if err != nil {
                self.presentAlert(title: "HATA", message: err!.localizedDescription)
            }
        }
    }
    
    // Kaydet butonuna tıklandığında çağrılan fonksiyon
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        let profilePicUrl = "profileImageUrl"
        
        profileVM.updateProfile(name: name, username: username) { error in
            if let error = error {
                self.presentAlert(title: "HATA", message: error.localizedDescription)
            }
        }
    }
    
    // Alert fonksiyonu
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
