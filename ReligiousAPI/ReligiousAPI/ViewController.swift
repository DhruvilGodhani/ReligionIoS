//
//  ViewController.swift
//  ReligiousAPI
//
//  Created by ADMIN on 13/12/24.
//

import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var quotesAPI: [QuoteModel] = []
    var quotesCD: [QuoteModel] = []
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableAPI: UITableView!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var tableCD: UITableView!
    var selectedQuote: QuoteModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.quotesCD = CDManager().readData()
        reloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table view setup
        tableCD.delegate = self
        tableCD.dataSource = self
        tableCD.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        tableAPI.delegate = self
        tableAPI.dataSource = self
        tableAPI.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        // Initialize UI
        segment.selectedSegmentIndex = 0
        tableCD.isHidden = true
        
        // Fetch data
        fetchQuotesAF { response in
            switch response {
            case .success(let data):
                self.quotesAPI.append(contentsOf: data)
                self.reloadTable()
            case .failure(let error):
                debugPrint(error)
            }
        }
        self.quotesCD = CDManager().readData()
        self.reloadTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tableAPI ? quotesAPI.count : quotesCD.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell from the corresponding table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        if tableView == tableAPI {
            // Ensure valid index
            guard indexPath.row < quotesAPI.count else {
                return UITableViewCell() // Return empty cell if index is invalid
            }
            // Populate with API data
            cell.quoteLabel.text = quotesAPI[indexPath.row].quote
            cell.religionLabel.text = quotesAPI[indexPath.row].religion
            cell.sourceLabel.text = quotesAPI[indexPath.row].source
        } else {
            // Ensure valid index
            guard indexPath.row < quotesCD.count else {
                return UITableViewCell() // Return empty cell if index is invalid
            }
            // Populate with Core Data data
            cell.quoteLabel.text = quotesCD[indexPath.row].quote
            cell.religionLabel.text = quotesCD[indexPath.row].religion
            cell.sourceLabel.text = quotesCD[indexPath.row].source
        }
        return cell
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            if self.segment.selectedSegmentIndex == 0 {
                self.tableAPI.reloadData()
            } else if self.segment.selectedSegmentIndex == 1{
                self.tableCD.reloadData()
            }
        }
    }
    
    @IBAction func changedSegment(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            tableAPI.isHidden = false
            tableCD.isHidden = true
            reloadTable()
        } else {
            self.quotesCD = CDManager().readData()
            tableAPI.isHidden = true
            tableCD.isHidden = false
            reloadTable()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableAPI {
            guard indexPath.row < quotesAPI.count else { return } // Ensure valid index
            let selectedQuote = quotesAPI[indexPath.row]
            CDManager().addData(quoteData: selectedQuote)
            tableAPI.deselectRow(at: indexPath, animated: true)
        } else {
            guard indexPath.row < quotesCD.count else { return } // Ensure valid index
            tableCD.deselectRow(at: indexPath, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdate" {
            if let updateVC = segue.destination as? updateVC {
                updateVC.selectedQuote = selectedQuote
            }
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == tableCD {
            
            let updateAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler) in
            
                self.selectedQuote = self.quotesCD[indexPath.row]
                self.performSegue(withIdentifier: "GoToUpdate", sender: self)
                
                completionHandler(true)
            }
            updateAction.backgroundColor = .systemOrange
            updateAction.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
            let updateConfig = UISwipeActionsConfiguration(actions: [updateAction])
            
            return updateConfig
        } else {
            let updateConfig = UISwipeActionsConfiguration(actions: [])
            
            return updateConfig
        }
        // Determine which array to use based on segment
    }
    
    func deleteFromArr(position: Int) {
        quotesCD.remove(at: position)
        DispatchQueue.main.async {
            self.tableCD.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == tableCD {
            // Define the delete action
            let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [self] action, view, completion in
                // Get the quote to delete
                let quoteToDelete = quotesCD[indexPath.row]
                
                // Perform delete from Core Data
                CDManager().deleteFromCD(quote: quoteToDelete)
                
                // Remove the quote from the array and update the table
                deleteFromArr(position: indexPath.row)
                
                // Indicate completion
                completion(true)
            }
            
            // Configure the delete action appearance
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "minus.circle.fill")
            
            // Return the swipe actions configuration
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else {
            // For the API table, no swipe actions
            return UISwipeActionsConfiguration(actions: [])
        }
    }

}
