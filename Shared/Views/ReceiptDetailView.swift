//
//  ReceiptDetailView.swift
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

struct ReceiptDetailView: View
{
    @State var receiptObj: Receipt
    
    var body: some View
    {
        Text("Receipt ID: \(receiptObj.id)").font(.title2)
        Text("Active: \(receiptObj.active_flag ? 1 : 0)")
        if let cr = receiptObj.created { Text("Created: \(cr, formatter: itemFormatter)") }
        if let lu = receiptObj.last_updated { Text("Last Updated: \(lu, formatter: itemFormatter)") }
        Text("Last Updated User Entity ID: \(receiptObj.last_updated_user_entity_id)")
        Text("Product Item ID: \(receiptObj.product_item_id)")
        Text("Received Quantity: \(receiptObj.received_quantity)")
        if let rd = receiptObj.sent_date { Text("Rent date: \(rd, formatter: itemFormatter)") }
        if let ti = receiptObj.transient_identifier { Text("Transient ID: \(ti)") }
    }
}

struct ReceiptDetailView_Previews: PreviewProvider {
    static let receiptObj = Receipt()
    static var previews: some View {
        ReceiptDetailView(receiptObj: receiptObj)
    }
}

//active_flag: Bool
//created: Date?
//id: Int32
//last_updated: Date?
//last_updated_user_entity_id: Int32
//product_item_id: Int32
//received_quantity: Int32
//sent_date: Date?
//transient_identifier: String?
//invoices: Invoice?
