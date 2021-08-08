//
//  InvoiceDetailView.swift
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

struct InvoiceDetailView: View
{
    @State var invoiceObj: Invoice
    
    private var inReceipts: Array<Receipt>
    {
        guard let its = invoiceObj.receipts else
        {
            return []
        }
        
        return its.allObjects as! Array<Receipt>
    }
    
    var body: some View
    {
        InvoiceData(invoiceObj: $invoiceObj)
        if (inReceipts.count > 0) {
            Divider().background(Color.blue)
            InvoiceReceipts(receipts: inReceipts)
        }
    }
}

private struct InvoiceData: View
{
    @Binding var invoiceObj: Invoice
    var body: some View {
        Text("Invoice ID: \(invoiceObj.id)").font(.title2)
        Text("Active: \(invoiceObj.active_flag ? 1 : 0)")
        if let cr = invoiceObj.created { Text("Created: \(cr, formatter: itemFormatter)") }
        if let iN = invoiceObj.invoice_number { Text("Invoice number: \(iN)") }
        if let lu = invoiceObj.last_updated { Text("Last Updated: \(lu, formatter: itemFormatter)") }
        Text("Last Updated User Entity ID: \(invoiceObj.last_updated_user_entity_id)")
        if let rd = invoiceObj.receipt_sent_date { Text("Receipt sent date: \(rd, formatter: itemFormatter)") }
        Text("Received Status: \(invoiceObj.received_status)")
        if let ti = invoiceObj.transient_identifier { Text("Transient ID: \(ti)") }
    }
}

private struct InvoiceReceipts: View
{
    let receipts: Array<Receipt>
    var body: some View {
        Text("Receipts")
            .font(.title)
        ForEach (receipts) { receipt in
            ReceiptDetailView(receiptObj: receipt)
        }
    }
}

struct InvoiceDetailView_Previews: PreviewProvider
{
    static let invoiceObj = Invoice()
    static var previews: some View
    {
        InvoiceDetailView(invoiceObj: invoiceObj)
    }
}

//active_flag: Bool
//created: Date?
//id: Int32
//invoice_number: String?
//last_updated: Date?
//last_updated_user_entity_id: Int32
//receipt_sent_date: Date?
//received_status: Int16
//transient_identifier: String?
//purchase_orders: Purchase_Order?
//receipts: NSSet?
