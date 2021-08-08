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
    @EnvironmentObject private var appEnv: AppEnvironmentData
    @State var poObj: Purchase_Order
    
    private var poItems: Array<Item>
    {
        guard let its = poObj.items else
        {
            return []
        }
        
        return its.allObjects as! Array<Item>
    }
    
    private var poInvoice: Array<Invoice>
    {
        guard let its = poObj.invoices else
        {
            return []
        }
        
        return its.allObjects as! Array<Invoice>
    }

    var body: some View
    {
        List
        {
            Group
            {
                POApprovalStatus(poObj: $poObj)
                POKeyDates(poObj: $poObj)
                POStringData(poObj: $poObj)
            }
            Group
            {
                if (poInvoice.count > 0 ) {
                    Divider().background(Color.blue)
                    POInvoices(invoices: poInvoice)
                }
            }
            Group
            {
                if (poItems.count > 0)
                {
                    Divider().background(Color.blue)
                    POItems(items: poItems)
                }
            }
            NavigationLink(destination: ItemEditView(poObj: $poObj))
            {
                Label("Add Item to PO", systemImage: "plus")
            }
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

private struct POItems: View
{
    var items: Array<Item>
    var body: some View
    {
        Text("Items")
            .font(.title)
        ForEach (items) { item in
            ItemDetailView(itemObj: item)
        }
    }
}

private struct POInvoices: View
{
    let invoices: Array<Invoice>
    var body: some View
    {
        Text("Invoices")
            .font(.title)
        ForEach (invoices) { invoice in
            InvoiceDetailView(invoiceObj: invoice)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let po = Purchase_Order()
    static var previews: some View {
        PODetailView(poObj: po)
    }
}


