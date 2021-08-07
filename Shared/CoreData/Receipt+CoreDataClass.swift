//
//  Receipt+CoreDataClass.swift
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

@objc(Receipt)
public class Receipt: NSManagedObject, Decodable
{
    private enum CodingKeys: String, CodingKey
    {
        case active_flag
        case created
        case id
        case last_updated
        case last_updated_user_entity_id
        case product_item_id
        case received_quantity
        case sent_date
        case transient_identifier
    }
    
    required convenience public init(from decoder: Decoder) throws
    {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else
        {
            fatalError("NSManagedObjectContext is missing")
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Receipt", in: context)!
        self.init(entity: entity, insertInto: context)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active_flag = try values.decode(Bool.self, forKey: .active_flag)
        created = try? values.decode(Date.self, forKey: .created)
        id = try values.decode(Int32.self, forKey: .id)
        last_updated = try? values.decode(Date.self, forKey: .last_updated)
        last_updated_user_entity_id = try values.decode(Int32.self, forKey: .last_updated_user_entity_id)
        product_item_id = try values.decode(Int32.self, forKey: .product_item_id)
        received_quantity = try values.decode(Int32.self, forKey: .received_quantity);
        sent_date = try? values.decode(Date.self, forKey: .sent_date)
        transient_identifier = try values.decode(String.self, forKey: .transient_identifier)
    }
}
