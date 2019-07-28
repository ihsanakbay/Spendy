//
//  ViewController.swift
//  Spendy
//
//  Created by Ihsan Akbay on 2019-06-23.
//  Copyright © 2019 Ihsan Akbay. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class WalletVC: UIViewController, AddWalletDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyPageView: UIView!
    
    var wallets = [Wallet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = emptyPageView
        tableView.backgroundView?.isHidden = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWalletFromCoredata()
        self.tableView.reloadData()
        
    }
    
    func fetchWalletFromCoredata(){
        self.fetchFromCoredata { (complete) in
            if complete {
                if wallets.count >= 1 {
                    self.wallets = self.wallets.reversed()
                }
            }
        }
    }
    
    func fetchFromCoredata(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<Wallet>(entityName: "Wallet")
        do {
            wallets =  try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeFromCoreData(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.delete(wallets[indexPath.row])
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func walletAdded() {
        self.fetchWalletFromCoredata()
        tableView.reloadData()
    }
    
    
    
}

extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if wallets.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell") as? WalletCell else {return UITableViewCell()}
        let wallet = wallets[indexPath.row]
        cell.configureCell(wallet: wallet)
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
            self.fetchWalletFromCoredata()
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        
        deleteAction.image = UIImage(named: "trash")
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TransactionVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TransactionVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedWallet = wallets[indexPath.row]
            }
        }
        if let vc2 = segue.destination as? AddWalletVC {
            vc2.delegate = self
        }
    }
}
