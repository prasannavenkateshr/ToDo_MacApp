//
//  ViewController.swift
//  To-Do List
//
//  Created by Prasanna Venkatesh on 15/10/17.
//  Copyright © 2017 Scoobb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteBtn: NSButton!
    
    var itemstodo : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importantCheckbox.state = NSControl.StateValue(rawValue: 0)

        // Do any additional setup after loading the view.
        fetchToDoItems()
    }
    
    func fetchToDoItems () {
        // get from coredata
        if let contxt = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                //setting them to class property
               itemstodo = try contxt.fetch(ToDoItem.fetchRequest())
                print (itemstodo.count)
            } catch { }
        }
        // updating the tableView
        tableView.reloadData()
    }

    @IBAction func addTasks(_ sender: Any) {
        if textField.stringValue != "" {
            if let contxt = (NSApplication.shared .delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDoItem = ToDoItem (context: contxt)
                toDoItem.name = textField.stringValue
                if importantCheckbox.state.rawValue == 0 {
                    toDoItem.important = false
                } else { toDoItem.important = true }
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                textField.stringValue = ""
                importantCheckbox.state = NSControl.StateValue(rawValue: 0)
                fetchToDoItems()
                deleteBtn.isHidden = true
            }
        }
    }
    
    @IBAction func doDelete(_ sender: Any) {
        let item = itemstodo[tableView.selectedRow]
        
        if let contxt = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            contxt.delete(item)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            fetchToDoItems()
            deleteBtn.isHidden = true
        }
        
    }
    
    // MARK: Table View and other updating stuffs
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return itemstodo.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let todo = itemstodo[row]
        if (tableColumn?.identifier)!.rawValue == "impColumn" {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "impCell"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = todo.important ? " ⭐️ " : ""
                return cell
            }
        } else {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoCell"), owner: self) as? NSTableCellView {
            cell.textField?.stringValue = todo.name!
            return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteBtn.isHidden = false
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

