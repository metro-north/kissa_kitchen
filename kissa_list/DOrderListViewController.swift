//
//  DOrderListViewController.swift
//  kissa_list
//
//  Created by Kei Kawamura on 2018/09/20.
//  Copyright © 2018年 Kei Kawamura. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DOrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // インスタンス変数
    var DBRef:DatabaseReference!
    var hogearray : [String] = []
    var array1 : [String] = []
    var d1amount = Array(repeating: "0", count: 20)
    var d2amount = Array(repeating: "0", count: 20)
    var d3amount = Array(repeating: "0", count: 20)
    var d4amount = Array(repeating: "0", count: 20)
    var time = Array(repeating: "0", count: 20)
    var dateUnix: TimeInterval = 0
    var hogetime : String?
    var nowrow : String?
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hogearray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tablelabel = cell.contentView.viewWithTag(1) as! UILabel
        let d1label = cell.contentView.viewWithTag(2) as! UILabel
        let d2label = cell.contentView.viewWithTag(3) as! UILabel
        let d3label = cell.contentView.viewWithTag(4) as! UILabel
        let d4label = cell.contentView.viewWithTag(5) as! UILabel
        
        var status1 : String?
        var intstatus1 : Int?
        let defaultPlacex = DBRef.child("table/dstatus").child(hogearray[indexPath.row])
        defaultPlacex.observe(.value) { (snap: DataSnapshot) in status1 = (snap.value! as AnyObject).description
            intstatus1 = Int(status1!)
            if intstatus1! == 1||intstatus1! == 2{
                cell.contentView.backgroundColor = UIColor.cyan
            }else{
                cell.contentView.backgroundColor = UIColor.clear
            }
        }
        
        let defaultPlace0 = self.DBRef.child("table/order").child(self.hogearray[indexPath.row]).child("time")
        defaultPlace0.observe(.value) { (snap: DataSnapshot) in self.hogetime = (snap.value! as AnyObject).description
            self.dateUnix = TimeInterval(self.hogetime!)!
            let hogedate = NSDate(timeIntervalSince1970: self.dateUnix/1000)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            self.time[indexPath.row] = formatter.string(from: hogedate as Date)
        }
        let defaultPlace = self.DBRef.child("table/order").child(self.hogearray[indexPath.row]).child("d1amount")
        defaultPlace.observe(.value) { (snap: DataSnapshot) in self.d1amount[indexPath.row] = (snap.value! as AnyObject).description}
        let defaultPlace1 = self.DBRef.child("table/order").child(self.hogearray[indexPath.row]).child("d2amount")
        defaultPlace1.observe(.value) { (snap: DataSnapshot) in self.d2amount[indexPath.row] = (snap.value! as AnyObject).description}
        let defaultPlace2 = self.DBRef.child("table/order").child(self.hogearray[indexPath.row]).child("d3amount")
        defaultPlace2.observe(.value) { (snap: DataSnapshot) in self.d3amount[indexPath.row] = (snap.value! as AnyObject).description}
        let defaultPlace3 = self.DBRef.child("table/order").child(self.hogearray[indexPath.row]).child("d4amount")
        defaultPlace3.observe(.value) { (snap: DataSnapshot) in self.d4amount[indexPath.row] = (snap.value! as AnyObject).description}
        
        
        tablelabel.text = "\(String(describing: self.time[indexPath.row])) Table\(String(describing:self.hogearray[indexPath.row]))"
        d1label.text =  "\(String(describing:self.d1amount[indexPath.row]))"
        d2label.text =  "\(String(describing:self.d2amount[indexPath.row]))"
        d3label.text =  "\(String(describing:self.d3amount[indexPath.row]))"
        d4label.text =  "\(String(describing:self.d4amount[indexPath.row]))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.nowrow = hogearray[indexPath.row]
        let alertController = UIAlertController(title: "調理済み",message: "", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
            self.DBRef.child("table/dstatus").child(self.nowrow!).setValue(1)
            self.DBRef.child("table/status").child(self.nowrow!).setValue(2)
        }
        
        let cancelButton = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        
        present(alertController,animated: true,completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //インスタンスを作成
        DBRef = Database.database().reference()
        //オーダーリストの取得
        let defaultPlace = DBRef.child("table/orderorder")
        defaultPlace.observe(.value, with: { snapshot in
            var array: [String] = []
            for item in (snapshot.children) {
                let snapshot = item as! DataSnapshot
                let dict = snapshot.value as! String
                array.append(dict)
            }
            DispatchQueue.main.async {
                self.hogearray = array
            }
        })
        Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(self.newArray(_:)),
            userInfo: nil,
            repeats: true
        )
    }
    @objc func newArray(_ sender: Timer) {
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
