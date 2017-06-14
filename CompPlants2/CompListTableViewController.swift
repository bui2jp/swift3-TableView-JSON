//
//  CompListTableViewController.swift
//  CompPlants2
//
//  Created by Takuya on 2017/05/29.
//  Copyright © 2017年 Takuya. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompListTableViewController: UITableViewController, UISearchResultsUpdating {

    var searchController = UISearchController()

    //compPlantTBL.jsonからデータを取得して初期化する
    var compplantslist = [(id: "dummy", name: "dummy", url: "dummy", srchtext: "dummy", sortkey: "dummy"),]
    //検索後のリスト
    var compplantslist_tmp = [(id: "dummy", name: "dummy", url: "dummy", srchtext: "dummy", sortkey: "dummy")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

        /*
         compPlantTBL.jsonからデータを取得して初期化する
         */
        do{
            let file = Bundle.main.path(forResource: "compPlantTBL", ofType: "json")
            let data = try Data(contentsOf: URL(fileURLWithPath: file!))
            print(data)
            
            let jsonCompPlantTBL = JSON(data)
            print(jsonCompPlantTBL)
            
            //
            //json data to arrary(compplantslist)
            //
            print("--------------------jsonCompPlantTBL--------------------")
            compplantslist.removeAll()
            for i in 0..<jsonCompPlantTBL["vegetables"].count {
                print(jsonCompPlantTBL["vegetables"][i]["id"].string!)
                print(jsonCompPlantTBL["vegetables"][i]["name"].string!)
                print(jsonCompPlantTBL["vegetables"][i]["sortkey"].string!)
                print(jsonCompPlantTBL["vegetables"][i]["srchtext"].string!)
                
                compplantslist.insert(
                    (id: jsonCompPlantTBL["vegetables"][i]["id"].string!,
                     name: jsonCompPlantTBL["vegetables"][i]["name"].string!,
                     url: jsonCompPlantTBL["vegetables"][i]["imgfile"].string!,
                     srchtext: jsonCompPlantTBL["vegetables"][i]["srchtext"].string!,
                     sortkey: jsonCompPlantTBL["vegetables"][i]["sortkey"].string!), at: 0)
            }
        }catch let error{
            print (error)
        }
    

        /*
         tmpリストを初期化してすべていれておく
        */
        compplantslist_tmp = []
        //sort by "sortkey"
        compplantslist_tmp = compplantslist.sorted{ $0.4 < $1.4 }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true;
        
        tableView.tableHeaderView = searchController.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return compplantslist_tmp.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomViewCell

        // Configure the cell...
        
        let Data = compplantslist_tmp[indexPath.row]

        //cell.textLabel?.text = Data.name;
        //cell.detailTextLabel?.text = Data.url
        cell.textLabel?.text = nil;
        cell.detailTextLabel?.text = nil
        //cell.setCell(vg_icon_name: Data.url, name: Data.name)
        cell.vegName.text = Data.name
        
        //cell.imageView?.image = UIImage(named: Data.url)
        cell.veg_image.image = UIImage(named: Data.url)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            print("showDetail start...")
            /*
            if let veg_data = compplantslist_tmp[indexPath.row]
            
            (segue.desti)
            */
            if let indexPath = self.tableView.indexPathForSelectedRow {
                    let vegData = compplantslist_tmp[indexPath.row]
                    (segue.destination as! CompDetailViewController).passed_data["id"] = vegData.id
                    (segue.destination as! CompDetailViewController).passed_data["name"] = vegData.name
            }

        }
        
        //search barを非表示
        //searchController.
    }

    // 文字が入力される度に呼ばれる
    func updateSearchResults(for searchController: UISearchController) {
        /*
        self.searchResults = PPAP.filter{
            // 大文字と小文字を区別せずに検索
            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
 */
        let srcText: String = searchController.searchBar.text!
        if srcText != "" {
            let tmp = compplantslist.filter{
                    $0.srchtext.lowercased().contains(searchController.searchBar.text!.lowercased())
                }
            compplantslist_tmp = tmp.sorted{ $0.4 < $1.4 } 
        }else{
            compplantslist_tmp = compplantslist.sorted{ $0.4 < $1.4 }
        }
        
        self.tableView.reloadData()
    }

}
