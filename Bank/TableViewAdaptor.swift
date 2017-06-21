//
//  TableViewAdaptor.swift
//  Dining
//
//  Created by Paul Ossenbruggen on 2/25/17.
//
// Note: this class is very reusable. It can handle multiple section types, with little or
// no modification due to the use of generics. The currently hardcoded heights etc can be 
// moved into the configuration code, or be moved into properties.
//

import UIKit

protocol TableViewDataManagerDelegate : class {
    func update()
}

protocol TableSectionAdaptor {
    var cellReuseIdentifier: String { get }
    var title: String { get }
    var height : CGFloat { get }
    var itemCount : Int { get }
    func configure(cell: UITableViewCell, index: Int)
}


class TableViewAdaptorSection<Cell, Model> : TableSectionAdaptor {
    internal let cellReuseIdentifier: String
    internal let title: String
    internal let height: CGFloat
    internal var items: [Model]
    
    init(cellReuseIdentifier: String,
         title: String,
         height: CGFloat,
         items: [Model],
         configure: @escaping ( Cell, Model, Int ) -> Void)
    {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.title = title
        self.height = height
        self.items = items
        self.configure = configure
    }
    
    internal var itemCount: Int {
        return items.count
    }
    
    internal func configure(cell: UITableViewCell, index: Int) {
        configure(cell as! Cell, items[index], index)
    }
    
    internal var configure: ( Cell, Model, Int ) -> Void
}


class TableViewAdaptor: NSObject, UITableViewDataSource, UITableViewDelegate, TableViewDataManagerDelegate {
    public var headerHeight : CGFloat = 20.0
    public var footerHeight : CGFloat = 20.0
    private let tableView: UITableView
    private let didChangeHandler: () -> Void
    public var sections : [TableSectionAdaptor]
    
    init(tableView: UITableView,
         sections: [TableSectionAdaptor],
         didChangeHandler: @escaping () -> Void)
    {
        self.tableView = tableView
        self.didChangeHandler = didChangeHandler
        self.sections = sections
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:section.cellReuseIdentifier, for: indexPath)
        section.configure(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? headerHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? footerHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].height
    }
    
    public func update() {
        DispatchQueue.main.async {
            self.didChangeHandler()
        }
    }
}
