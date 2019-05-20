//
//  DataModel.swift
//  Contacts
//
//  Created by Soumil on 11/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit

class DataModel: NSObject {

    static let shared = DataModel()
    var name = [String]()
    var number = [String]()
    var key = [Int]()
    let colors:[UIColor] = [.red,.blue,.orange,.gray]
    var searchKey = ""
    var searchResult = [String]()
}
