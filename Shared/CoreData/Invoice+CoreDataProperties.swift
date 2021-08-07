//
//  Invoice+CoreDataProperties.swift
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

extension Invoice
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invoice>
    {
        return NSFetchRequest<Invoice>(entityName: "Invoice")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var created: Date?
    @NSManaged public var id: Int32
    @NSManaged public var invoice_number: String?
    @NSManaged public var last_updated: Date?
    @NSManaged public var last_updated_user_entity_id: Int32
    @NSManaged public var receipt_sent_date: Date?
    @NSManaged public var received_status: Int16
    @NSManaged public var transient_identifier: String?
    @NSManaged public var purchase_orders: Purchase_Order?
    @NSManaged public var receipts: NSSet?
}

// MARK: Generated accessors for receipts
extension Invoice
{
    @objc(addReceiptsObject:)
    @NSManaged public func addToReceipts(_ value: Receipt)

    @objc(removeReceiptsObject:)
    @NSManaged public func removeFromReceipts(_ value: Receipt)

    @objc(addReceipts:)
    @NSManaged public func addToReceipts(_ values: NSSet)

    @objc(removeReceipts:)
    @NSManaged public func removeFromReceipts(_ values: NSSet)
}

extension Invoice : Identifiable
{
}
