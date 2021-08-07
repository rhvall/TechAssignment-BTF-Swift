//
//  Purchase_Order+CoreDataProperties.swift
//  BttrflCD
//
//  Created by R on 8/7/21.
//
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

import Foundation
import CoreData

extension Purchase_Order
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Purchase_Order>
    {
        return NSFetchRequest<Purchase_Order>(entityName: "Purchase_Order")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var approval_status: Int16
    @NSManaged public var delivery_note: String?
    @NSManaged public var device_key: String?
    @NSManaged public var id: Int32
    @NSManaged public var issue_date: Date?
    @NSManaged public var last_updated: Date?
    @NSManaged public var last_updated_user_entity_id: Int32
    @NSManaged public var preferred_delivery_date: Date?
    @NSManaged public var purchase_order_number: String?
    @NSManaged public var sent_date: Date?
    @NSManaged public var server_timestamp: Int64
    @NSManaged public var status: Int16
    @NSManaged public var supplier_id: Int32
    @NSManaged public var cancelations: NSSet?
    @NSManaged public var invoices: NSSet?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for cancelations
extension Purchase_Order
{
    @objc(addCancelationsObject:)
    @NSManaged public func addToCancelations(_ value: Item)

    @objc(removeCancelationsObject:)
    @NSManaged public func removeFromCancelations(_ value: Item)

    @objc(addCancelations:)
    @NSManaged public func addToCancelations(_ values: NSSet)

    @objc(removeCancelations:)
    @NSManaged public func removeFromCancelations(_ values: NSSet)
}

// MARK: Generated accessors for invoices
extension Purchase_Order
{
    @objc(addInvoicesObject:)
    @NSManaged public func addToInvoices(_ value: Invoice)

    @objc(removeInvoicesObject:)
    @NSManaged public func removeFromInvoices(_ value: Invoice)

    @objc(addInvoices:)
    @NSManaged public func addToInvoices(_ values: NSSet)

    @objc(removeInvoices:)
    @NSManaged public func removeFromInvoices(_ values: NSSet)
}

// MARK: Generated accessors for items
extension Purchase_Order
{
    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Purchase_Order : Identifiable
{
}
