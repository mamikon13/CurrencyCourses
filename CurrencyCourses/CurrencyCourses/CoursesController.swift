//
//  CoursesControllerTableViewController.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 16/01/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import UIKit

class CoursesController: UITableViewController {

    @IBAction func pushRefreshAction(_ sender: Any) {
        Model.sharedInstance.loadXMLFile(date: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("startLoadingXML"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                activityIndicator.startAnimating()
                
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("dataRefreshed"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async {
                self.navigationItem.title = Model.sharedInstance.currentDate
                self.tableView.reloadData()
                
                let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
                
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
        

        NotificationCenter.default.addObserver(forName: NSNotification.Name?(NSNotification.Name(rawValue: "errorWhileXMLLoading")), object: nil, queue: nil) { (notification) in
            
            let errorDesc = notification.userInfo?["ErrorDescription"]
            print(errorDesc!)
            
            
            var startIndex = errorDesc.debugDescription.firstIndex(of: "\"")
            startIndex = errorDesc.debugDescription.index(startIndex!, offsetBy: 1)
            let lastIndex = errorDesc.debugDescription.lastIndex(of: "\"")
            let errorString = String(errorDesc.debugDescription[startIndex!..<lastIndex!])
            
            
            let errorAlert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            errorAlert.addAction(alertAction)

            DispatchQueue.main.async {
                let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
                
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
                
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        
        navigationItem.title = Model.sharedInstance.currentDate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let strDate = Model.sharedInstance.currentDate
        Model.sharedInstance.loadXMLFile(date: MySimpleDateFormatter().fromStringToDate(date: strDate))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.sharedInstance.currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CourceCell
        
        let courceForCell = Model.sharedInstance.currencies[indexPath.row]
        cell.initCell(currency: courceForCell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
