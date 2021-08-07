//
//  Purchase_Order+CoreDataClass.swift
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

public class Purchase_Order: NSManagedObject, Decodable
{
    private enum CodingKeys: String, CodingKey
    {
        case active_flag
        case approval_status
        case delivery_note
        case device_key
        case id
        case issue_date
        case last_updated
        case last_updated_user_entity_id
        case preferred_delivery_date
        case purchase_order_number
        case sent_date
        case server_timestamp
        case status
        case supplier_id
        case cancellations
        case invoices
        case items
    }
    
    required convenience public init(from decoder: Decoder) throws
    {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else
        {
            fatalError("NSManagedObjectContext is missing")
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Purchase_Order", in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active_flag = try values.decode(Bool.self, forKey: .active_flag)
        approval_status = try values.decode(Int16.self, forKey: .approval_status)
        delivery_note = try values.decode(String.self, forKey: .delivery_note)
        device_key = try values.decode(String.self, forKey: .device_key)
        id = try values.decode(Int32.self, forKey: .id)
        issue_date = try? values.decode(Date.self, forKey: .issue_date)
        last_updated = try values.decode(Date.self, forKey: .last_updated)
        last_updated_user_entity_id = try values.decode(Int32.self, forKey: .last_updated_user_entity_id)
        preferred_delivery_date = try values.decode(Date.self, forKey: .preferred_delivery_date)
        purchase_order_number = try values.decode(String.self, forKey: .purchase_order_number)
        sent_date = try? values.decode(Date.self, forKey: .sent_date)
        server_timestamp = try values.decode(Int64.self, forKey: .server_timestamp)
        status = try values.decode(Int16.self, forKey: .status)
        supplier_id = try values.decode(Int32.self, forKey: .supplier_id)
        cancellations = try values.decode(Set<Item>.self, forKey: .cancellations) as NSSet
        invoices = try values.decode(Set<Invoice>.self, forKey: .invoices) as NSSet
        items = try values.decode(Set<Item>.self, forKey: .items) as NSSet
    }
}
