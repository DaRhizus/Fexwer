import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol ProfileDelegate: AnyObject {
    func updateUI()
    func putPersonalInfos(with datas: MyPersonalData)
    func didUpdateProfile(success: Bool)
}

class ProfileVM {
    weak var delegate: ProfileDelegate?

    var currUserId = Auth.auth().currentUser?.uid
    var db = Firestore.firestore()
    var phozulls: [String] = []

    func numberOfRows() -> Int {
        return phozulls.count
    }

    func fetchMyPhozulls(completion: @escaping (Error?) -> Void) {
        phozulls.removeAll()

        guard let userId = currUserId else { return }

        db.collection("Posts").whereField("phozullOwner", isEqualTo: userId).getDocuments { querySnap, err in
            if let error = err {
                completion(error)
            } else {
                querySnap?.documents.forEach { doc in
                    if let phozullUrl = doc.data()["phozullUrl"] as? String {
                        self.phozulls.append(phozullUrl)
                    }
                }
                self.delegate?.updateUI()
                completion(nil)
            }
        }
    }

    func fetchMyProfileInfos(completion: @escaping (Error?) -> Void) {
        guard let userId = currUserId else { return }
        db.collection("users").whereField("id", isEqualTo: userId).getDocuments { querySnap, err in
            if let error = err {
                completion(error)
            } else {
                var myPersonalData: MyPersonalData?

                querySnap?.documents.forEach { doc in
                    if let name = doc.data()["name"] as? String,
                       let surname = doc.data()["surname"] as? String,
                       let username = doc.data()["username"] as? String,
                       let profilePic = doc.data()["profilePicUrl"] as? String {
                        myPersonalData = MyPersonalData(myProfileImage: profilePic, myName: name, mySurname: surname, myUserName: username)
                    }
                }
                if let data = myPersonalData {
                    self.delegate?.putPersonalInfos(with: data)
                }
                completion(nil)
            }
        }
    }

    // Yeni fonksiyon: Profil güncelleme
    func updateProfile(name: String, username: String, completion: @escaping (Error?) -> Void) {
        guard let userId = currUserId else { return }

        let updatedData: [String: Any] = [
            "name": name,
            "username": username
        ]

        
        db.collection("users").whereField("id", isEqualTo: currUserId).getDocuments(completion: { snap, err in
            if let snap , !snap.isEmpty {
                let doc = snap.documents.first?.reference
                
                guard let doc else { return }
                doc.updateData(updatedData) { err in
                    if let error = err {
                        completion(error)
                        self.delegate?.didUpdateProfile(success: false)
                    } else {
                        completion(nil)
                        self.delegate?.didUpdateProfile(success: true)
                    }
                }
            }
        })
            
            
    }
}
