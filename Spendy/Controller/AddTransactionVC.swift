//
//  AddTransactionVC.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-30.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit
import CoreData

protocol AddTransactionDelegate {
    func transactionAdded()
}

class AddTransactionVC: UIViewController {
    
    @IBOutlet weak var usernoteTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var delegate: AddTransactionDelegate?
    var selectedWallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        usernoteTextField.delegate = self
        amountTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [NSAttributedString.Key.foregroundColor : UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2470588235))])
        usernoteTextField.attributedPlaceholder = NSAttributedString(string: "General", attributes: [NSAttributedString.Key.foregroundColor : UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2470588235))])
        
        
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor(cgColor: #colorLiteral(red: 0.4862745098, green: 0.2039215686, blue: 0.7490196078, alpha: 1))
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(cgColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))], for: .normal)
        }

    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        amountTextField.text = ""
        usernoteTextField.text = ""
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        saveTransactionToCoredata { (success) in
            if success {
                delegate?.transactionAdded()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    func saveTransactionToCoredata(completion: (_ success: Bool)->()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let transaction = Transaction(context: managedContext)
        
        if usernoteTextField.text == "" {
            transaction.transactionName = "General"
        } else {
            transaction.transactionName = self.usernoteTextField.text!
        }
        
        transaction.transactionDate = getCurrentDate()
        transaction.transactionAmount = self.amountTextField.text!.doubleConverter
        if segmentedControl.selectedSegmentIndex == 0 {
            transaction.expenseAmount = self.amountTextField.text!.doubleConverter
        } else {
            transaction.incomeAmount = self.amountTextField.text!.doubleConverter
        }
        transaction.selectedIndex = Int32(self.segmentedControl.selectedSegmentIndex)
        
        transaction.wallet = self.selectedWallet
        
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

extension AddTransactionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernoteTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amountTextField.resignFirstResponder()
        usernoteTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == amountTextField) {
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
