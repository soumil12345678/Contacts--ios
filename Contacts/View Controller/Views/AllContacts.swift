//
//  AllContacts.swift
//  Contacts
//
//  Created by Soumil on 10/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit

class AllContacts: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var allContactsTable: UITableView!    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataLibrery.shared.fetchData()
        allContactsTable.tag = 2
        searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2 {
        return DataModel.shared.name.count
        }
        else {
            return DataModel.shared.searchResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 2 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! AllContactsTableViewCell
        cell.nameLabel.text = DataModel.shared.name[indexPath.row]
        cell.numberLabel.text = DataModel.shared.number[indexPath.row]
        cell.callButton.tag = indexPath.row
        cell.callButton.addTarget(self, action: #selector(callButtonAction(_:)), for: .touchUpInside)
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor.orange
            }
        return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! SearchTableViewCell
            if (DataModel.shared.searchResult.count) >= 0 {
                cell.nameLabel.text = DataModel.shared.searchResult[indexPath.row]
                cell.numberLabel.text = DataModel.shared.number[indexPath.row]
                cell.callButton.addTarget(self, action: #selector(callButtonAction(_:)), for: .touchUpInside)                
            }
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor.orange
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag != 2 {
            
        }
    }
    
    @objc func callButtonAction(_ sender: UIButton) {
        let url = URL(string: "tel://\(DataModel.shared.number[sender.tag])")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DataModel.shared.searchKey = ""
        DataModel.shared.searchResult.removeAll()
        allContactsTable.isHidden = true
        searchTableView.isHidden = false
        searchTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchTableView.reloadData()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchTableView.reloadData()
//    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        DataModel.shared.searchKey = DataModel.shared.searchKey + text
        if (DataModel.shared.searchKey != "") || (DataModel.shared.searchKey != " ") {
            filterContentForSearchText(searchText: DataModel.shared.searchKey)
            let  char = text.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                DataModel.shared.searchKey = String(DataModel.shared.searchKey.dropLast())
                filterContentForSearchText(searchText: DataModel.shared.searchKey)
            }
        }
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        DataModel.shared.searchResult = DataModel.shared.name.filter { item in
            return item.lowercased().contains(searchText.lowercased())
        }
        searchTableView.reloadData()
    }
}
