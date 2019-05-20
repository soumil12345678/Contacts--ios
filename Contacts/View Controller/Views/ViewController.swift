//
//  ViewController.swift
//  Contacts
//
//  Created by Soumil on 10/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
   
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var searchResultTable: UITableView!    
    @IBOutlet weak var backButton: UIBarButtonItem!
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        DataLibrery.shared.fetchData()
        let itemSize = UIScreen.main.bounds.width/2 - 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionview.collectionViewLayout = layout
        searchbar.delegate = self
        searchbar.showsCancelButton = false
    }

    //    MARK:- Collection view Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if DataModel.shared.name.count > 0 {
            return DataModel.shared.name.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as! HomeCollectionViewCell
        cell.firstLetterLabel.text = String(DataModel.shared.name[indexPath.row].first!).uppercased()
        cell.nameLabel.text = DataModel.shared.name[indexPath.row]
        if index > 3 {
            index = 0
        }
        cell.backgroundColor = DataModel.shared.colors[index]
        cell.OptionButton.tag = indexPath.row
        cell.OptionButton.addTarget(self, action: #selector(OptionButtonAction(_:)), for: .touchUpInside)
        index += 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: "tel://\(DataModel.shared.number[indexPath.row])")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func OptionButtonAction(_ sender: UIButton) {
    }
    
    //    MARK:- Table view Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DataModel.shared.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        if (DataModel.shared.searchResult.count) >= 0 {
            cell.textLabel?.text = DataModel.shared.searchResult[indexPath.row]
        }
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.orange
        }
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let url = URL(string: "tel://\(DataModel.shared.number[indexPath.row])")
        print("Tapped at:")
        print(indexPath.row)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
   
    @IBAction func barButtonAction(_ sender: UIBarButtonItem) {
        backButton.isEnabled = false
        searchbar.resignFirstResponder()
        collectionview.isHidden = false
        searchResultTable.isHidden = true
        searchbar.text = ""
        collectionview.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DataModel.shared.searchKey = ""
        DataModel.shared.searchResult.removeAll()
        backButton.isEnabled = true
        collectionview.isHidden = true
        searchResultTable.isHidden = false
        searchResultTable.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        DataModel.shared.searchKey = ""
        DataModel.shared.searchResult.removeAll()
     searchResultTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DataModel.shared.searchResult.removeAll()
        DataModel.shared.searchKey = searchBar.text!
        filterContentForSearchText(searchText: DataModel.shared.searchKey)
        searchBar.resignFirstResponder()
        searchResultTable.reloadData()
    }
    
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
        searchResultTable.reloadData()
    }
}

