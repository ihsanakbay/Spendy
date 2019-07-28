//
//  TransactionVC.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-26.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit
import CoreData

class TransactionVC: UIViewController, AddTransactionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!
    @IBOutlet var emptyPageView: UIView!
    
    
    var selectedWallet: Wallet? {
        didSet{
            fetchTransactionFromCoredata()
        }
    }
    var transactions = [Transaction]()
    
    var sumOfExpense: Double = 0.0
    var sumOfIncome: Double = 0.0
    var amountValue: Double = 0.0
    var sum: Double = 0.0
    var totalExpenseValue: Double?
    var totalIncomeValue: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = emptyPageView
        tableView.backgroundView?.isHidden = true
        navigationItem.title = selectedWallet!.walletName!
        expenseLabel.text = getCurrency(value: totalExpenseValue ?? 0.00)
        incomeLabel.text = getCurrency(value: totalIncomeValue ?? 0.00)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.displayTotal()
    }
    
    func setTotalExpense() -> Double {
        var temp: Double = 0.0
        for i in transactions {
            temp = temp + i.expenseAmount
        }
        sumOfExpense = temp
        return sumOfExpense
    }
    
    func setTotalIncome() -> Double {
        var temp: Double = 0.0
        for i in transactions {
            temp = temp + i.incomeAmount
        }
        sumOfIncome = temp
        return sumOfIncome
    }
    
    func setRemaining() {
        var temp: Double = 0.0
        temp = selectedWallet!.walletAmount - setTotalExpense() + setTotalIncome()
        self.remainLabel.text = getCurrency(value: temp)
    }
    
    func displayTotal(){
        totalExpenseValue = setTotalExpense()
        totalIncomeValue = setTotalIncome()
        setRemaining()
        expenseLabel.text = getCurrency(value: totalExpenseValue!)
        incomeLabel.text = getCurrency(value: totalIncomeValue!)
    }

    
    @IBAction func addTransactionClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddTransactionVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddTransactionVC{
            vc.selectedWallet = self.selectedWallet!
            vc.delegate = self
        }
    }
    


    func fetchTransactionFromCoredata(){
        self.fetchFromCoredata { (complete) in
            if complete {
                if transactions.count >= 1 {
                    self.transactions = self.transactions.reversed()
                }
            }
        }
    }
    
    func fetchFromCoredata(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        let predicate = NSPredicate(format: "wallet.walletName == %@", selectedWallet!.walletName!)
        fetchRequest.predicate = predicate
        do {
            transactions =  try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeFromCoreData(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(transactions[indexPath.row])
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
        self.displayTotal()
    }
    
    func transactionAdded() {
        self.fetchTransactionFromCoredata()
        tableView.reloadData()
        self.displayTotal()
    }
    

}

extension TransactionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if transactions.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else { return UITableViewCell() }
        
        let data = transactions[indexPath.row]
        cell.configureCell(transaction: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completion) in
            self.removeFromCoreData(atIndexPath: indexPath)
            self.fetchTransactionFromCoredata()
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        deleteAction.image = UIImage(named: "trash")
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }

    
    
}
