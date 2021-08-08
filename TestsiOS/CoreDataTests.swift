//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by R on 8/6/21.
//

// //////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 or later.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
// //////////////////////////////////////////////////////////

@testable import BttrflCD
import XCTest
import Foundation
import CoreData

enum XCTestsError: Error
{
    case fileNotFound
    case invalidOperation(_ named: String)
    case invalidFile(_ error: Error)
}

class CoreDataTests: XCTestCase
{
    private var container: NSPersistentContainer!
    private let cdModelName = "CDModel"
    
    override func setUpWithError() throws
    {
        guard let dummyContainer = try? loadCDTestModel(cdModelName) else
        {
            XCTFail("Could not load CoreData Model");
            return
        }
        
        container = dummyContainer
        continueAfterFailure = false
    }

    override func tearDownWithError() throws
    {
        container = nil
    }
    
    func testJSONParsingForItem() throws
    {
        let str = """
        {
            "id": 1,
            "product_item_id": 1,
            "quantity": 10,
            "last_updated_user_entity_id": 200,
            "transient_identifier": "tid",
            "active_flag": true,
            "last_updated": "2020-05-07T09:32:28.213Z"
        }
        """
        
        let str2 = """
        {
            "id": 1,
            "product_item_id": 2,
            "ordered_quantity": 11,
            "last_updated_user_entity_id": 0,
            "created": "2020-05-07T09:32:28.213Z",
            "transient_identifier": "string"
        }
        """
        
        decodeTestJSON(type: Item.self, str: str, cntx: container.viewContext) { itemResult in
            XCTAssertNotNil(itemResult, "Item parsing should not be nil")
            XCTAssertNotNil(itemResult.last_updated, "Item ´last_updated´ property should not be nil")
            XCTAssertTrue(itemResult.active_flag, "Item ´active_flag´ property should be true")
            XCTAssertNotNil(itemResult.transient_identifier, "Item ´transient_identifier´ property should not be nil")
        }
        
        decodeTestJSON(type: Item.self, str: str2, cntx: container.viewContext) { itemResult in
            XCTAssertNotNil(itemResult, "Item parsing should not be nil")
            XCTAssertNil(itemResult.last_updated, "Item ´last_updated´ property should be nil")
            XCTAssertFalse(itemResult.active_flag, "Item ´active_flag´ property should not be true")
            XCTAssertNotNil(itemResult.created, "Item ´created´ property should not be nil")
            XCTAssertEqual(itemResult.transient_identifier, "string", "Item ´transient_identifier´ property should be ´string´")
        }
    }
    
    func testJSONParsingForReceipt()
    {
        let str = """
        {
            "id": 110,
            "product_item_id": 110,
            "received_quantity": 20,
            "created": "2020-05-07T09:32:28.213Z",
            "last_updated_user_entity_id": 10,
            "transient_identifier": "tid2",
            "sent_date": "2020-05-07T09:32:28.213Z",
            "active_flag": true,
            "last_updated": "2020-05-07T09:32:28.213Z"
        }
        """
        
        decodeTestJSON(type: Receipt.self, str: str, cntx: container.viewContext) { itemResult in
            XCTAssertNotNil(itemResult, "Item parsing should not be nil")
            XCTAssertNotNil(itemResult.last_updated, "Item ´last_updated´ property should not be nil")
            XCTAssertTrue(itemResult.active_flag, "Item ´active_flag´ property should be true")
            XCTAssertNotNil(itemResult.transient_identifier, "Item ´transient_identifier´ property should not be nil")
        }
    }
    
    func testJSONParsingForInvoice()
    {
        let str = """
        {
            "id": 11,
            "invoice_number": "101",
            "received_status": 1,
            "created": "2020-05-07T09:32:28.213Z",
            "last_updated_user_entity_id": 10,
            "transient_identifier": "tid",
            "receipts": [
            {
                "id": 110,
                "product_item_id": 110,
                "received_quantity": 20,
                "created": "2020-05-07T09:32:28.213Z",
                "last_updated_user_entity_id": 10,
                "transient_identifier": "tid2",
                "sent_date": "2020-05-07T09:32:28.213Z",
                "active_flag": true,
                "last_updated": "2020-05-07T09:32:28.213Z"
            }
            ],
            "receipt_sent_date": "2020-05-07T09:32:28.213Z",
            "active_flag": true,
            "last_updated": "2020-05-07T09:32:28.213Z"
        }
        """
        
        decodeTestJSON(type: Invoice.self, str: str, cntx: container.viewContext) { itemResult in
            XCTAssertNotNil(itemResult, "Item parsing should not be nil")
            XCTAssertNotNil(itemResult.created, "Item ´created´ property should not be nil")
            XCTAssertNotNil(itemResult.invoice_number, "Item ´invoice_number´ property should not be nil")
            XCTAssertEqual(itemResult.transient_identifier, "tid", "Item ´transient_identifier´ property should be tid")
            XCTAssertNotNil(itemResult.receipt_sent_date, "Item ´receipt_sent_date´ property should not be nil")
            XCTAssertTrue(itemResult.active_flag, "Item ´active_flag´ property should be true")
            XCTAssertNotNil(itemResult.last_updated, "Item ´last_updated´ property should not be nil")
            XCTAssertNotNil(itemResult.receipts, "Item ´receipts´ property should not be nil")
        }
    }
    
    func testJSONParsingForPO()
    {
        let testBundle = Bundle(for: type(of: self))
        
        guard let dataPath = testBundle.url(forResource: "purchase_order", withExtension: "json") else
        {
            XCTFail("No JSON file located")
            return
        }
        
        do {
            let str = try String(contentsOf: dataPath)
            decodeTestJSON(type: [Purchase_Order].self, str: str, cntx: container.viewContext) { results in
                results.forEach { itemResult in
                    XCTAssertNotNil(itemResult, "Item parsing should not be nil")
                    XCTAssertNotNil(itemResult.issue_date, "Item ´issue_date´ property should not be nil")
                    XCTAssertNotNil(itemResult.sent_date, "Item ´sent_date´ property should not be nil")
                    XCTAssertTrue(itemResult.active_flag, "Item ´active_flag´ property should be true")
                    XCTAssertNotNil(itemResult.last_updated, "Item ´last_updated´ property should not be nil")
                    XCTAssertNotNil(itemResult.cancellations, "Item ´cancelations´ property should not be nil")
                    XCTAssertNotNil(itemResult.invoices, "Item ´invoices´ property should not be nil")
                    XCTAssertNotNil(itemResult.items, "Item ´items´ property should not be nil")
                }
            }
        }
        catch
        {
            XCTFail("Reading JSON string not possible \(error)")
        }
    }
    
    func dummyPO(mocContext: NSManagedObjectContext, lastID: Int32) -> Purchase_Order
    {
        let poBase = Purchase_Order(context: mocContext)
        poBase.id = lastID + 1
        poBase.last_updated = Date()
        poBase.active_flag = true
        poBase.approval_status = 2
        poBase.delivery_note = "mm"
        poBase.device_key = "mm1"
        poBase.issue_date = Date()
        poBase.last_updated = Date()
        poBase.last_updated_user_entity_id = 43
        poBase.preferred_delivery_date = Date()
        poBase.purchase_order_number = "String"
        poBase.sent_date = Date()
        poBase.server_timestamp = 449
        poBase.status = 10
        poBase.supplier_id = 20
        
        let item = Item(context: mocContext)
        item.active_flag = true
        item.created = Date()
        item.id = lastID
        item.last_updated = Date()
        item.last_updated_user_entity_id = 32
        item.ordered_quantity = 3
        item.product_item_id = 5
        item.quantity = 10
        item.transient_identifier = "-:String?"
        item.puchase_orders = poBase
//        item.cancelled_purchase_orders: Purchase_Order?
        
        let invoice = Invoice(context: mocContext)
        invoice.id = lastID
        invoice.active_flag = true
        invoice.created = Date()
        invoice.invoice_number = ": String?-"
        invoice.last_updated = Date()
        invoice.last_updated_user_entity_id = 3
        invoice.receipt_sent_date = Date()
        invoice.received_status = 4
        invoice.transient_identifier = "Stringss"
        invoice.purchase_orders = poBase
        
        let receipt = Receipt(context: mocContext)
        receipt.id = lastID
        receipt.active_flag = true
        receipt.created = Date()
        receipt.last_updated = Date()
        receipt.last_updated_user_entity_id = 484
        receipt.product_item_id = 939
        receipt.received_quantity = 919
        receipt.sent_date = Date()
        receipt.transient_identifier = "¿¿String??"
        receipt.invoices = invoice
        invoice.receipts = [receipt]

        poBase.items = [item]
        poBase.invoices = [invoice]
        return poBase
    }
    
    
    func decodeTestJSON<T>(type: T.Type, str: String, cntx: NSManagedObjectContext, tests: (T)->Void)
        where T : Decodable
    {
        let decoder = JSONDecoder(context: cntx)
        do {
            let dta = str.data(using: .utf8)!
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let itemResult = try decoder.decode(type, from: dta)
            tests(itemResult);
        }
        catch
        {
            XCTFail("Decoding not possible \(error)")
        }
    }
    
    func loadCDTestModel(_ momdName: String) throws -> NSPersistentContainer
    {
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else
        {
            throw XCTestsError.fileNotFound // Error("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else
        {
            throw XCTestsError.invalidOperation("Error initializing mom from: \(modelURL)")
        }

        let container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        
        if let storeDescription = container.persistentStoreDescriptions.first {
            storeDescription.shouldAddStoreAsynchronously = true
            storeDescription.url = URL(fileURLWithPath: "/dev/null")
            storeDescription.shouldAddStoreAsynchronously = false
        }
        
        return container
    }

//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
