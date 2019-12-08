//
//  TableViewController.swift
//  onTheMap
//
//  Created by Aly Essam on 8/22/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit

let cellIdentifier = "cellIdentifier"
class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentsLocation(completion: handleResponse(students:error:))
    }
    func handleResponse(students: [student], error: Error?) {
        if error != nil{
            raiseAlertView(withTitle: "Failure", withMessage: error! .localizedDescription)
        } else {
            StudentModel.students = students
            self.tableView.reloadData()
        }
    }

    @IBAction func refreshPressed(_ sender: Any) {
        UdacityClient.getStudentsLocation(completion: handleResponse(students:error:))
    }
    
 
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.students.count
    }

    @IBAction func logOutPressed(_ sender: Any) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
       let student = StudentModel.students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? "")" + "\(student.lastName ?? "")"
        cell.detailTextLabel?.text = ("\(student.mediaURL ?? "")")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudent = StudentModel.students[indexPath.row]
        let selectedStudentLink = selectedStudent.mediaURL
        guard selectedStudentLink != "" else{
            return
        }
        guard  UIApplication.shared.canOpenURL(URL(string: selectedStudentLink!)!) == true else {
            raiseAlertView(withTitle: "Invalid URL", withMessage: "It is invalid URL")
            return
        }
        UIApplication.shared.open(URL(string: selectedStudentLink!)!)
    }
}
