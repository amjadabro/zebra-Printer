////
////  PrintJobHelper.swift
////  Printer
////
////  Created by Amjad on 15/06/1440 AH.
////  Copyright © 1440 Amjad. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//enum PrinterType {
//    case checkout
//    case kitchen
//    case packaging
//    case all
//}
//
//fileprivate class OrderToPrint {
//    var orderDetails: OrderDetailStruct
//    var cartItems: [CartItemStruct]
//    
//    init(orderDetails: OrderDetailStruct, cartItems: [CartItemStruct]) {
//        self.orderDetails = orderDetails
//        self.cartItems = cartItems
//    }
//}
//
//class PrintJobHelper {
//    
//    static fileprivate var printJobsArray: [OrderToPrint] = [OrderToPrint]()
//    static private var availablePrinters = [PrinterDetailsModel]()
//    static fileprivate var receiptConfigurationModel: ReceiptConfigurationModel!
//    
//    // MARK:- Public Static Methods
//    
//    /// Fetches and sets printers in 'availablePrinters'
//    ///
//    /// - Returns: Void
//    static func setPrinters() {
//        availablePrinters.removeAll()
//        if let printerDetailModels = getPrinterDetailsModels(printerType: .all) {
//            for printerDetailModel in printerDetailModels {
//                availablePrinters.append(printerDetailModel)
//            }
//        }
//    }
//    
//    /// Setting receipt configuration in model
//    ///
//    /// - Returns: Void
//    static func setReceiptConfigurationModel() {
//        PrintJobHelper.receiptConfigurationModel = getReceiptConfigurationModel()
//    }
//    
//    /// Prints receipt of all types
//    static fileprivate func printReceipt() {
//        if printJobsArray.count == 0 {
//            return
//        }
//        let printJob: OrderToPrint? = printJobsArray.first
//        if let orderToPrint = printJob {
//            let printer = availablePrinters.filter{$0.isPrinting == false}.first
//            let printerType = orderToPrint.orderDetails.orderPrinterType
//            print("Printer availablity: \(printer?.isPrinting)")
//            if let printer = printer {
//                printer.isPrinting = true
//                print("Printer availablity T: \(printer.isPrinting)")
//                let printJob = PrintJob()
//                switch printerType! {
//                case .checkout:
//                    printJob.printCheckoutReceipt(printerDetails: printer, orderDetails: orderToPrint.orderDetails, cartItems: orderToPrint.cartItems) { (isSuccess, message) in
//                        print(isSuccess, message)
//                        printer.isPrinting = false
//                        print("Printer availablity FC: \(printer.isPrinting)")
//                        if !isSuccess {
//                            printJobsArray.removeAll()
//                            UIUtility.showAlert(title: message)
//                        }
//                    }
//                case .kitchen:
//                    printJob.printKitchenReceipt(printerDetails: printer, orderDetails: orderToPrint.orderDetails, cartItems: orderToPrint.cartItems) { (isSuccess, message) in
//                        print(isSuccess, message)
//                        printer.isPrinting = false
//                        print("Printer availablity FK: \(printer.isPrinting)")
//                        if !isSuccess {
//                            printJobsArray.removeAll()
//                            UIUtility.showAlert(title: message)
//                        }
//                    }
//                case .packaging:
//                    break
//                case .all:
//                    break
//                }
//            }
//        }
//    }
//    
//    /// Adds kitchen order in print job queue
//    /// - Parameters:
//    ///     - orderDetails: OrderStruct
//    ///     - cartItems: [CartItemStruct]
//    /// - Returns: Void
//    static func addKitchenOrderInPrinterQueue(orderDetails: OrderDetailStruct, cartItems: [CartItemStruct]) {
//        let printers = availablePrinters.filter{$0.isKitchenPrinter == true}
//        if printers.count > 0 {
//            let orderToPrint = OrderToPrint(orderDetails: orderDetails, cartItems: cartItems)
//            orderToPrint.orderDetails.orderPrinterType = PrinterType.kitchen
//            printJobsArray.append(orderToPrint)
//            printReceipt()
//        } else {
//            UIUtility.showAlert(title: "No kitchen printer found.")
//        }
//    }
//    
//    /// Adds checkout order in print job queue
//    /// - Parameters:
//    ///     - orderDetails: OrderStruct
//    ///     - cartItems: [CartItemStruct]
//    /// - Returns: Void
//    static func addCheckoutOrderInPrinterQueue(orderDetails: OrderDetailStruct, cartItems: [CartItemStruct]) {
//        let printers = availablePrinters.filter{$0.isCashPrinter == true}
//        if printers.count > 0 {
//            let orderToPrint = OrderToPrint(orderDetails: orderDetails, cartItems: cartItems)
//            orderToPrint.orderDetails.orderPrinterType = PrinterType.checkout
//            printJobsArray.append(orderToPrint)
//            printReceipt()
//        } else {
//            UIUtility.showAlert(title: "No Checkout printer found.")
//        }
//    }
//    
//    // MARK:- fileprivate Methods
//    
//    /// Fetches company details from Database
//    ///
//    /// - Returns: CompanyInfo?
//    static fileprivate func getCompanyInfo()-> CompanyInfo? {
//        if let _ = getReceipt() {
//            //            let companyInfo = CompanyInfo(logo: UIImage(named: "store.png")!, name: receipt.companyTitle!, phoneNumber: receipt.companyPhones!, valueAddedTaxNumber: "1234567890", snapchatLink: receipt.snapchatLink!, instagranLink: receipt.instagramLink!)
//            
//            let companyInfo = CompanyInfo(logo: UIImage(named: "store.png")!, name: "The Store", phoneNumber: "0123456456", valueAddedTaxNumber: "1234567890", snapchatLink: "marnpos", instagranLink: "marnpos1")
//            return companyInfo
//        }
//        return nil
//    }
//    
//    /// Returns the ReceiptConfigurationModel fetched and transformed from CoreData
//    ///
//    /// - Returns: ReceiptConfigurationModel
//    static private func getReceiptConfigurationModel()-> ReceiptConfigurationModel {
//        if let configuration = getReceiptConfiguration() {
//            let configurationModel = ReceiptConfigurationModel()
//            configurationModel.isPrintReceipt = configuration.isPrintReceipt
//            configurationModel.showKitchenHangingSpace = configuration.showKitchenHangingSpace
//            configurationModel.showLogo = configuration.showLogo
//            configurationModel.showCompanyName = configuration.showCompanyName
//            configurationModel.showAddress = configuration.showAddress
//            configurationModel.showPhone = configuration.showPhone
//            configurationModel.showEmail = configuration.showEmail
//            configurationModel.showWebsite = configuration.showWebsite
//            configurationModel.showTable = configuration.showTable
//            return configurationModel
//        } else {
//            return ReceiptConfigurationModel()
//        }
//    }
//    
//    /// Returns the PrinterDetailsModels fetched and transformed from CoreData
//    /// - Parameters:
//    ///     - printerType: PrinterType
//    /// - Returns: [PrinterDetailsModel]?
//    fileprivate static func getPrinterDetailsModels(printerType: PrinterType)-> [PrinterDetailsModel]? {
//        let allPrinters = getPrinters(printerType: printerType)
//        if let printers = allPrinters, printers.count > 0 {
//            var availablePrinters = [PrinterDetailsModel]()
//            for printer in printers {
//                let myPrinter = PrinterDetailsModel()
//                myPrinter.model = printer.model
//                myPrinter.ipAddress = printer.ipAddress
//                myPrinter.target = printer.target
//                myPrinter.isCashPrinter = printer.isCashPrinter
//                myPrinter.isKickDrawer = printer.isKickDrawer
//                myPrinter.isKitchenPrinter = printer.isKitchenPrinter
//                myPrinter.numberOfCopies = printer.numberOfCopies
//                myPrinter.alias = printer.alias
//                myPrinter.manufacturer = PrinterManufacturer(rawValue: printer.manufacturer)
//                myPrinter.isConnected = true
//                myPrinter.macAddress = printer.macAddress
//                myPrinter.isPrinting = false
//                availablePrinters.append(myPrinter)
//            }
//            return availablePrinters
//        } else {
//            return nil
//        }
//    }
//    
//    // MARK:- CoreData Related Methods
//    
//    /// Gets Company details to print on Checkout Receipt
//    ///
//    /// - Returns: Receipt?
//    static fileprivate func getReceipt()-> Receipt? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Receipt")
//        do {
//            let results = try DataController.context.fetch(fetchRequest) as! [Receipt]
//            return results.first
//        } catch {
//            print("error in retrieving")
//            return nil
//        }
//    }
//    
//    /// Gets connected checkout printers from DB
//    /// - Parameters:
//    ///     - printerType: PrinterType
//    ///
//    /// - Returns: [PrinterDetails]?
//    private static func getPrinters(printerType: PrinterType)-> [PrinterDetails]? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PrinterDetails")
//        
//        switch printerType {
//        case .checkout:
//            fetchRequest.predicate = NSPredicate(format: "isCashPrinter == true")
//            break
//        case .kitchen:
//            fetchRequest.predicate = NSPredicate(format: "isKitchenPrinter == true")
//            break
//        case .packaging:
//            fetchRequest.predicate = NSPredicate(format: "isCashPrinter == true")
//            break
//        case .all:
//            break
//        }
//        
//        do {
//            let results = try DataController.context.fetch(fetchRequest) as! [PrinterDetails]
//            return results
//        } catch {
//            print("error in retrieving")
//            return nil
//        }
//    }
//    
//    /// Gets receipt configuration
//    ///
//    /// - Returns: ReceiptConfiguration?
//    static private func getReceiptConfiguration()-> ReceiptConfiguration? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReceiptConfiguration")
//        do {
//            let results = try DataController.context.fetch(fetchRequest) as! [ReceiptConfiguration]
//            return results.first
//        } catch {
//            print("error in retrieving")
//            return nil
//        }
//    }
//    
//}
//
//fileprivate class PrintJob {
//    
//    private var printerContext: PrinterContext?
//    
//    func printPackagingReceipt(orderToPrint: OrderDetailStruct, completion: @escaping (Bool, String) -> ()) {
//        if let printerDetails = PrintJobHelper.getPrinterDetailsModels(printerType: .checkout)?.first {
//            printerContext = PrinterContext(strategy: EpsonPrinterHelper())
//            let packagingReceiptBuilder = PackagingReceiptBuilder(orderToPrint: orderToPrint)
//            packagingReceiptBuilder.setWidthOfReceipt(width: ConstantValues._4inchScale)
//            let packagingReceiptImage = packagingReceiptBuilder.createReceiptImage()
//            printerContext?.printReceipt(printerDetailsModel: printerDetails, printImage: packagingReceiptImage) { (isSuccess, message) in
//                completion(isSuccess, message)
//            }
//        }
//    }
//    
//    /// Prints checkout receipt
//    /// - Parameters:
//    ///     - printerDetails: PrinterDetailsModel
//    ///     - orderDetails: OrderStruct
//    ///     - cartItems: [CartItemStruct]
//    ///     - (Bool, String) -> ()
//    func printCheckoutReceipt(printerDetails: PrinterDetailsModel, orderDetails: OrderDetailStruct, cartItems: [CartItemStruct], completion: @escaping (Bool, String) -> ()) {
//        
//        switch printerDetails.manufacturer! {
//        case PrinterManufacturer.epson:
//            printerContext = PrinterContext(strategy: EpsonPrinterHelper())
//            break
//        case PrinterManufacturer.star:
//            break
//        }
//        
//        printerContext?.delegate = self
//        
//        let checkoutReceiptBuilder = CheckoutReceiptBuilder(orderDetails: orderDetails, cartItems: cartItems, receiptConfigurationModel: PrintJobHelper.receiptConfigurationModel, companyInfo: PrintJobHelper.getCompanyInfo()!)
//        checkoutReceiptBuilder.setWidthOfReceipt(width: ConstantValues._4inchScale)
//        let checkoutReceiptImage = checkoutReceiptBuilder.createReceiptImage()
//        printerContext?.printReceipt(printerDetailsModel: printerDetails, printImage: checkoutReceiptImage, isKickDrawer: printerDetails.isKickDrawer) { (isSuccess, message) in
//            completion(isSuccess, message)
//        }
//    }
//    
//    /// Prints Kitchen receipt
//    /// - Parameters:
//    ///     - printerDetails: PrinterDetailsModel
//    ///     - orderToPrint: OrderStruct
//    ///     - (Bool, String) -> ()
//    func printKitchenReceipt(printerDetails: PrinterDetailsModel, orderDetails: OrderDetailStruct, cartItems: [CartItemStruct], completion: @escaping (Bool, String) -> ()) {
//        
//        switch printerDetails.manufacturer! {
//        case PrinterManufacturer.epson:
//            printerContext = PrinterContext(strategy: EpsonPrinterHelper())
//            break
//        case PrinterManufacturer.star:
//            break
//        }
//        
//        printerContext?.delegate = self
//        
//        let kitchenReceiptBuilder = KitchenReceiptBuilder(orderDetails: orderDetails, cartItems: cartItems, receiptConfigurationModel: PrintJobHelper.receiptConfigurationModel)
//        kitchenReceiptBuilder.setWidthOfReceipt(width: ConstantValues._4inchScale)
//        let kitchenReceiptImage = kitchenReceiptBuilder.createReceiptImage()
//        printerContext?.printReceipt(printerDetailsModel: printerDetails, printImage: kitchenReceiptImage) { (isSuccess, message) in
//            completion(isSuccess, message)
//        }
//    }
//    
//    // MARK:- Mock Objects
//    
//    /// Mock Printer Details Object (for TESTING PURPOSE only)
//    ///
//    /// - Returns: PrinterDetailsModel
//    private func mockPrinterDetails()-> PrinterDetailsModel {
//        let printerDetailsModel = PrinterDetailsModel()
//        printerDetailsModel.model = "TM-m30"
//        printerDetailsModel.ipAddress = "192.168.0.233"
//        printerDetailsModel.target = "192.168.0.233"
//        printerDetailsModel.isCashPrinter = true
//        printerDetailsModel.isKickDrawer = true
//        printerDetailsModel.isKitchenPrinter = true
//        printerDetailsModel.numberOfCopies = 1
//        printerDetailsModel.alias = "TM-m30"
//        printerDetailsModel.manufacturer = .epson
//        printerDetailsModel.isConnected = true
//        printerDetailsModel.macAddress = "64:EB:8C:FE:2A:3E"
//        printerDetailsModel.isPrinting = false
//        return printerDetailsModel
//    }
//}
//
//// MARK:- Implementation of PrinterContextDelegate Methods
//
//extension PrintJob: PrinterContextDelegate {
//    func didPrint() {
//        if PrintJobHelper.printJobsArray.count > 0 {
//            print("Printer availablity Did Print called")
//            PrintJobHelper.printJobsArray.removeFirst()
//            PrintJobHelper.printReceipt()
//            printerContext = nil
//        }
//    }
//}
