//
//  CompDetailViewController.swift
//  CompPlants2
//
//  Created by Takuya on 2017/05/29.
//  Copyright © 2017年 Takuya. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompDetailViewController: UITableViewController {
    
    @IBOutlet weak var navi_item: UINavigationItem!
    

    
    var passed_data = ["id":"", "name":""]

    //var compplantslist = [(id: "dummy", sortkey: "dummy", name: "dummy", url: "dummy", stat_image: "dummy", desc: "dummy") ]

    var compplantslist_tmp = [(id: "dummy", sortkey:"dummy", name: "dummy", url: "dummy", stat_image: "dummy", desc: "dummy")]
    //var compplantslist_tmp = []
    
    override func viewDidLoad() {
        print("viewDidLoad...")
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //navi_item タイトルを設定する
        navi_item.title = passed_data["name"]
        
        /*
         compPlantTBL.jsonからデータを取得して初期化する
         passed_data["id"] の内容でtmpリストを更新する
         */
        do{
            let file = Bundle.main.path(forResource: "compPlantTBL", ofType: "json")
            let data = try Data(contentsOf: URL(fileURLWithPath: file!))
            print(data)
            
            let jsonCompPlantTBL = JSON(data)
            //print(jsonCompPlantTBL)
            
            //
            //json data to arrary(compplantslist_tmp)
            // json[0xx]とjson["benefit"]の内容でcompplantslist_tmpを更新する
            //
            //print("--------------------jsonCompPlantTBL--------------------")
            compplantslist_tmp.removeAll()
            
            let veg_id = passed_data["id"]
            
            for i in 0..<jsonCompPlantTBL[veg_id!].count {
                //print(jsonCompPlantTBL[veg_id!][i]["compid"].string!)
                //print(jsonCompPlantTBL[veg_id!][i]["benefit_id"].string!)

                var comp_name = "test name"
                //var stat_image = "flower"
                let stat_image = jsonCompPlantTBL[veg_id!][i]["benefit_id"].string!
                var veg_image = "flower"
                var sortkey = "test sortkey"
                var descText = "test desc"
                

                
                //veg_idからname,sortkey,benefit,imagefilenameを設定する
                let veg_arr = jsonCompPlantTBL["vegetables"].arrayValue
                let filteredData =
                veg_arr.filter(){
                    let item = $0
                    if (item["id"].stringValue == jsonCompPlantTBL[veg_id!][i]["compid"].string! ){
                        print(item["name"].stringValue)
                        comp_name = item["name"].stringValue
                        print(item["imgfile"].stringValue)
                        veg_image = item["imgfile"].stringValue
                        sortkey = item["sortkey"].stringValue
                        //stat_image = item["test"].stringValue
                        return true
                    }
                    return false
                }
                print(filteredData)
                
                //
                let benefit_arr = jsonCompPlantTBL["benefit"].arrayValue
                let filteredDT = benefit_arr.filter(){
                    let item = $0
                    if(item["benefit_id"].string == jsonCompPlantTBL[veg_id!][i]["benefit_id"].string!){
                        return true
                    }
                    return false
                }
                descText = filteredDT[0]["desc"].string!
                    
                compplantslist_tmp.insert(
                     (id: veg_id!,
                     sortkey: sortkey,
                     name: comp_name,
                     url: veg_image,
                     stat_image: stat_image,
                     desc: descText),
                    at: 0)
            }
        }catch let error{
            print (error)
        }
        

        //compplantslist_tmp = []
        //compplantslist_tmp = compplantslist.filter { $0.id ==  passed_data["id"]}
        compplantslist_tmp.sort{ $0.1 < $1.1 }
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
        //return compplantslist.count
    }

    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView... ")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! CompDetailCell

        // Configure the cell...
        //let Data = compplantslist[indexPath.row]
        let Data = compplantslist_tmp[indexPath.row]
        
        //set text
        cell.descText.text = Data.desc
        cell.nameText.text = Data.name

        //set image
        //cell.imageView?.image = UIImage(named: Data.url)
        cell.veg_image.image = UIImage(named: Data.url)
        
        
        cell.regCrossImg.isHidden = true
        if( Data.stat_image == "B" )
        {
            cell.regCrossImg.isHidden = false
        }
        //let image_tmp:UIImage? = UIImage(named: Data.stat_image)
        //cell.stat_img?.image = image_tmp
        

        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
