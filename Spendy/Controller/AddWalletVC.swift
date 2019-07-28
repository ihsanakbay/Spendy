//
//  AddWalletVC.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-23.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit
import CoreData

protocol AddWalletDelegate {
    func walletAdded()
}

class AddWalletVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    var delegate: AddWalletDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        amountField.delegate = self
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2470588235))])
        amountField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor : UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2470588235))])
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createClicked(_ sender: Any) {
        if nameField.text != "" {
            self.saveWalletToCoredata { (success) in
                if success{
                    delegate?.walletAdded()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func saveWalletToCoredata(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let wallet = Wallet(context: managedContext)
        
        if nameField.text == "" {
            wallet.walletName = "Wallet"
        } else {
            wallet.walletName = nameField.text!
        }
        
        wallet.walletAmount = amountField.text!.doubleConverter
        wallet.walletDate = getCurrentDate()
        
        do {
            try managedContext.save()
            debugPrint("Successfully saved.")
            completion(true)
        } catch{
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
}

extension AddWalletVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amountField.resignFirstResponder()
        nameField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == amountField) {
            let countDots = (textField.text?.components(separatedBy: ".").count)! - 1
            let countComma = (textField.text?.components(separatedBy: ",").count)! - 1
            let allowedCharacters = "0123456789.,"
            let allowedCharactersSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharactersSet = CharacterSet(charactersIn: string)
            
            if (countDots > 0 && string == ".") || (countComma > 0 && string == ",") {
                return false
            }
            return allowedCharactersSet.isSuperset(of: typedCharactersSet)
        }
        return true
    }
    
}
