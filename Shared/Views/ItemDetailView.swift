//
//  ItemDetailView.swift
//  BttrflCD-iOS
//
//  Created by R on 8/8/21.
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


import SwiftUI

struct ItemDetailView: View
{
    @State var itemObj: Item
    
    var body: some View
    {
        Text("Item ID: \(itemObj.id)").font(.title2)
        Text("Active: \(itemObj.active_flag ? 1 : 0)")
        if let cr = itemObj.created { Text("Created: \(cr, formatter: itemFormatter)") }
        if let lu = itemObj.last_updated { Text("Last Updated: \(lu, formatter: itemFormatter)") }
        Text("Last Updated User Entity ID: \(itemObj.last_updated_user_entity_id)")
        Text("Order Quantity: \(itemObj.ordered_quantity)")
        Text("Product Item ID: \(itemObj.product_item_id)")
        Text("Quantity: \(itemObj.quantity)")
        if let ti = itemObj.transient_identifier { Text("Transient ID: \(ti)") }
    }
}

struct ItemDetailView_Previews: PreviewProvider
{
    static let itemObj = Item()
    static var previews: some View
    {
        ItemDetailView(itemObj: itemObj)
    }
}

//active_flag: Bool
//created: Date?
//id: Int32
//last_updated: Date?
//last_updated_user_entity_id: Int32
//ordered_quantity: Int32
//product_item_id: Int32
//quantity: Int32
//transient_identifier: String?
//cancelled_purchase_orders: Purchase_Order?
//puchase_orders: Purchase_Order?
