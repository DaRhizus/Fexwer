

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title : String ,
                      message : String ,
                      style : UIAlertController.Style = .alert ,
                      actions : [UIAlertAction] = [UIAlertAction(title: "TAMAM", style: .cancel)]
    )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach { alertAction in
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true)
        
    }
}


