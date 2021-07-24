//
//  CandySearchVC.swift
//  CandySearch
//
//  Created by Amit Chaudhary on 7/24/21.
//

import UIKit

class CandySearchVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var candyTableView: UITableView!
    
    
    @IBOutlet weak var searchFooter: SearchFooter!
    
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
    
    var candies: [Candy] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCandies: [Candy] = []
    
    var isSearchBarEmpty: Bool {
        return (self.searchController.searchBar.text?.isEmpty == true)
    }
    
    var isFiltering: Bool {
        let searchBarscopeIsFiltering = self.searchController.searchBar.selectedScopeButtonIndex != 0
        return self.searchController.isActive && (!isSearchBarEmpty || searchBarscopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candies = Candy.getTotalCandies()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        self.searchController.searchBar.scopeButtonTitles = Category.allCases.map({
            $0.rawValue
        })
        
        self.searchController.searchBar.delegate = self
        
        // notifications for keyboard appearance and disappearance
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: .main) { (notification) in
            //self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (notification) in
            //
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = self.candyTableView.indexPathForSelectedRow {
            self.candyTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func filteredContentForSearchText(_ searchText: String, category: Category? = nil) {
        filteredCandies = candies.filter({ (candy: Candy) -> Bool in
            let doesCategoryMatch = category == .all || candy.category == category
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })
        candyTableView.reloadData()
    }
    
    func handleKeyboard(notification: Notification) {
        // 1
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }
        
        guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        // 2
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
    
}


//Mark : - UITableViewDelegate, UITableViewDataSource
extension CandySearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            self.searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
            return filteredCandies.count
        }
        return candies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let candy: Candy
        if isFiltering {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell.textLabel?.text = candy.name
        cell.detailTextLabel?.text = candy.category.rawValue
        return cell
    }
}

extension CandySearchVC {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        self.filteredContentForSearchText(searchBar.text!, category: category)
    }
}

extension CandySearchVC {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Category(rawValue:
                                    searchBar.scopeButtonTitles![selectedScope])
        self.filteredContentForSearchText(searchBar.text!, category: category)
    }
    
}















