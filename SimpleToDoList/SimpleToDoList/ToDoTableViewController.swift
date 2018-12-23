//
//  ToDoTableViewController.swift
//  SimpleToDoList
//
//  Created by SSO on 17/12/2018.
//  Copyright © 2018 sso. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, TodoCellDelegate {
    
    
    
    //배열
    var todoItems:[TodoItem]!

    override func viewDidLoad() {
        super.viewDidLoad()

    loadData()
    }

    func loadData() {
        //초기화
        todoItems = [TodoItem]()
        //자동정렬
        todoItems = DataManager.loadAll(TodoItem.self).sorted(by: {
            $0.createdAt < $1.createdAt
        })
        
        tableView.reloadData()
        
        
    }

    @IBAction func addNewTodo(_ sender: Any) {
        
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a title", preferredStyle: .alert)
        addAlert.addTextField{(textfield:UITextField)in textfield.placeholder = "ToDo Item title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: {(action:UIAlertAction)in
            
            guard let title = addAlert.textFields?.first?.text else{
                return
            }
            let newTodo = TodoItem(title:title,completed:false, createdAt: Date(), itemIdentifier:UUID())
            newTodo.saveItem()
            self.todoItems.append(newTodo)
        let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
        
        
    }
    func didRequestDelete(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for:cell){
            todoItems[indexPath.row].deleteItem()
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didRequestComplete(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            var todoItem = todoItems[indexPath.row]
            todoItem.markAsCompleted()
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
            
        }
    }
    func strikeThroughText (_ text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

  //cell재사용
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        
        cell.delegate = self
        
        //우리가 얻는 문자열 todoList 배열을 만들고 여기에 엑세스 하려면
        let todoItem = todoItems[indexPath.row]

      //셀을 호출하고 라벨을 붙이고텍스트를 설정
        cell.todoLabel.text = todoItem.title

        if todoItem.completed {
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
