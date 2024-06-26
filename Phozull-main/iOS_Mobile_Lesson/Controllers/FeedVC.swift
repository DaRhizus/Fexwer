

import UIKit

class FeedVC: UIViewController {

    var feedVM = FeedVM()
    
    @IBOutlet weak var phozullsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        let userDef = UserDefaults.standard.bool(forKey: "rememberMe")
        print(userDef)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        feedVM.fetchPhozulls()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }

   
}
