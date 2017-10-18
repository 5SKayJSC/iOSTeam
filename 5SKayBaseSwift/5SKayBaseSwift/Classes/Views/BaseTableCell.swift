//
//  BaseTableCell.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {
    // MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: deinit
    deinit {
        BLogInfo("")
    }
    
    // MARK: define for cell
    class func identifier() -> String {
        return String(describing: self.self)
    }
    
    class func height() -> CGFloat {
        return 0
    }
    
    class func registerCellByClass(_ tableView: UITableView) {
        tableView.register(self.self, forCellReuseIdentifier: self.identifier())
    }
    
    class func registerCellByNib(_ tableView: UITableView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.identifier())
    }
    
    class func loadCell(_ tableView: UITableView) -> BaseTableCell {
        return tableView.dequeueReusableCell(withIdentifier: self.identifier()) as! BaseTableCell
    }
    
}
