//
//  HardwareViewController.swift
//  Garage
//
//  Created by Amjad on 21/06/1440 AH.
//  Copyright © 1440 Amjad Ali. All rights reserved.
//

import UIKit

class HardwareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Epos2DiscoveryDelegate {
    
    let printers = [PrinterDetailsModel]()
    
    fileprivate var printerList: [Epos2DeviceInfo] = []
    fileprivate var filterOption: Epos2FilterOption = Epos2FilterOption()
    
    @IBOutlet weak var receiptPrinterTableview: UITableView!
    @IBOutlet weak var printertypelabel: UITextField!
    private var availablePrinters = [PrinterDetailsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        filterOption.deviceType = EPOS2_TYPE_PRINTER.rawValue
        
        receiptPrinterTableview.delegate = self
        receiptPrinterTableview.dataSource = self
         printertypelabel.text = Constants.Printer
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let result = Epos2Discovery.start(filterOption, delegate: self)
        if result != EPOS2_SUCCESS.rawValue {
            //ShowMsg showErrorEpos(result, method: "start")
            
        }
        receiptPrinterTableview.reloadData()
        
//        else {
//            Constants.Printer = UserDefaults.standard.string(forKey: "printer")!
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
          //  Constants.Printer = UserDefaults.standard.string(forKey: "printer")!
            
            
        while Epos2Discovery.stop() == EPOS2_ERR_PROCESSING.rawValue {
            // retry stop function
        }
        
        printerList.removeAll()
        
    }
    
    
    @IBAction func printerRemoveBtn(_ sender: Any) {

        if Constants.Printer != "" {
            Constants.Printer = ""
            printertypelabel.text = ""
            
        }
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNumber: Int = 0
        if section == 0 {
            rowNumber = printerList.count
        }
        else {
            rowNumber = 1
        }
        return rowNumber
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basis-cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        }
        
        if indexPath.section == 0 {
            if indexPath.row >= 0 && indexPath.row < printerList.count {
                cell!.textLabel?.text = printerList[indexPath.row].deviceName
                cell!.detailTextLabel?.text = printerList[indexPath.row].target
               
            }
        }
        else {
            cell!.textLabel?.text = "other..."
            cell!.detailTextLabel?.text = ""
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
          //  if delegate != nil {
                Constants.Printer = printerList[indexPath.row].target
            printertypelabel.text = "\(Constants.Printer)"
//            UserDefaults.standard.set(new, forKey: "printer")
//            UserDefaults.standard.synchronize()
//            let printerdetails = printerList[indexPath.row]
//
//            for printerdata in printerdetails {
//                printerdata.
//            }
//
            
            
                print("Added Successfully")
             NotificationCenter.default.post(name: Notification.Name("printerAdded"), object: nil)
            
                // navigationController?.popToRootViewController(animated: true)
           // }
            dismiss(animated: true, completion: nil)
            
        }
        else {
            performSelector(onMainThread: #selector(HardwareViewController.connectDevice), with:self, waitUntilDone:false)
        }
        
    }
    @objc func connectDevice() {
        Epos2Discovery.stop()
        printerList.removeAll()
        
        let btConnection = Epos2BluetoothConnection()
        let BDAddress = NSMutableString()
        let result = btConnection?.connectDevice(BDAddress)
        if result == EPOS2_SUCCESS.rawValue {
           
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            Epos2Discovery.start(filterOption, delegate:self)
            receiptPrinterTableview.reloadData()
        }
      //  PrinterDetailsModel
    }
//    @IBAction func restartDiscovery(_ sender: AnyObject) {
//        var result = EPOS2_SUCCESS.rawValue;
//
//        while true {
//            result = Epos2Discovery.stop()
//
//            if result != EPOS2_ERR_PROCESSING.rawValue {
//                if (result == EPOS2_SUCCESS.rawValue) {
//                    break;
//                }
//                else {
//                    MessageView.showErrorEpos(result, method:"stop")
//                    return;
//                }
//            }
//        }
//
//        printerList.removeAll()
//        printerView.reloadData()
//
//        result = Epos2Discovery.start(filterOption, delegate:self)
//        if result != EPOS2_SUCCESS.rawValue {
//            MessageView.showErrorEpos(result, method:"start")
//        }
//    }
    
    
    func onDiscovery(_ deviceInfo: Epos2DeviceInfo!) {
        printerList.append(deviceInfo)
        receiptPrinterTableview.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
