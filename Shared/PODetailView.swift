//
//  DetailView.swift
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

struct PODetailView: View
{
    @State var poObj: Purchase_Order

    var body: some View
    {
        List
        {
            POApprovalStatus(poObj: $poObj)
            POKeyDates(poObj: $poObj)
            POStringData(poObj: $poObj)
//            cancellations: NSSet?
//            invoices: NSSet?
//            items: NSSet?
        }
        .navigationTitle("Purchase Order ID: \(poObj.id)")
    }
}

private struct POKeyDates: View
{
    @Binding var poObj: Purchase_Order
    var body: some View
    {
        if let iD = poObj.issue_date { Text("Issue Date: \(iD, formatter: itemFormatter)") }
        if let lu = poObj.last_updated { Text("Last Date: \(lu, formatter: itemFormatter)") }
        if let pd = poObj.preferred_delivery_date { Text("Preferred Delivery Date: \(pd, formatter: itemFormatter)") }
        if let sd = poObj.sent_date { Text("Sent Date: \(sd, formatter: itemFormatter)") }
    }
}

private struct POStringData: View
{
    @Binding var poObj: Purchase_Order
    var body: some View
    {
        if let dn = poObj.delivery_note { Text("Delivery Note: \(dn)") }
        if let dk = poObj.device_key { Text("Device Key: \(dk)") }
        if let pn = poObj.purchase_order_number { Text("Purchase Order Number: \(pn)") }
    }
}

private struct POApprovalStatus: View
{
    @Binding var poObj: Purchase_Order
    var body: some View
    {
        Text("Active: \(poObj.active_flag ? 1 : 0)")
        Text("Approval Status: \(poObj.approval_status)")
        Text("Last Updated User Entity ID: \(poObj.last_updated_user_entity_id)")
        Text("Server Timestamp: \(poObj.server_timestamp)")
        Text("Status: \(Int(poObj.status))")
        Text("Supplier ID: \(poObj.supplier_id)")
    }
}

struct DetailView_Previews: PreviewProvider {
    static let po = Purchase_Order()
    static var previews: some View {
        PODetailView(poObj: po)
    }
}


