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
    private var purchaseOrder: [[String : Any]] = []
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
        
        guard let res = try? loadJSONFromBundle("purchase_orders", "json") else
        {
            XCTFail("Could not load JSON");
            return
        }
        
        guard let po = res as? [[String : Any]] else
        {
            XCTFail("JSON did not match Dictionary");
            return
        }
        
        purchaseOrder = po
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws
    {
        container = nil
        purchaseOrder = []
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
            XCTAssertTrue(itemResult.active_flag, "Item ´active_flag´ property should not be true")
            XCTAssertNotNil(itemResult.transient_identifier, "Item ´transient_identifier´ property should not be nil")
        }
    }
    
    func testJSONParsingForPO()
    {
//        guard let items = purchaseOrder[0]["items"] as? [[String : Any]] else {
//            XCTFail("Items were not found")
//            return
//        }
    }
    
    func decodeTestJSON<T>(type: T.Type, str: String, cntx: NSManagedObjectContext, tests: (T)->Void) where T : Decodable
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
    
    func loadJSONFromBundle(_ fileName: String, _ fileExtension: String) throws -> Any?
    {
        let testBundle = Bundle(for: type(of: self))
        
        guard let dataPath = testBundle.url(forResource: fileName, withExtension: fileExtension) else
        {
            throw XCTestsError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: dataPath)
            let jsonObj = try? JSONSerialization.jsonObject(with: data, options: [])
            return jsonObj
        }
        catch
        {
            throw XCTestsError.invalidFile(error)
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
