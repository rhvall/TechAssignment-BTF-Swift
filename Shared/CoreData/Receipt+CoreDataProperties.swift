//
//  Receipt+CoreDataProperties.swift
//  BttrflCD
//
//  Created by RH VT on 8/7/21.
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

extension Receipt
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt>
    {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var active_flag: Bool
    @NSManaged public var created: Date?
    @NSManaged public var id: Int32
    @NSManaged public var last_updated: Date?
    @NSManaged public var last_updated_user_entity_id: Int32
    @NSManaged public var product_item_id: Int32
    @NSManaged public var received_quantity: Int32
    @NSManaged public var sent_date: Date?
    @NSManaged public var transient_identifier: String?
    @NSManaged public var invoices: Invoice?
}

extension Receipt : Identifiable
{
}
