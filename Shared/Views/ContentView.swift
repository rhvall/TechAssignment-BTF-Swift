//
//  ContentView.swift
//  Shared
//
//  Created by R on 8/6/21.
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
import CoreData

struct ContentView: View
{
    @Environment(\.managedObjectContext) private var mocContext
    @EnvironmentObject private var appEnv: AppEnvironmentData
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Purchase_Order.id, ascending: false)],
        animation: .default)
    private var purchaseOrder: FetchedResults<Purchase_Order>
    
    var body: some View {
        List {
//--------------------------------------
            ForEach(purchaseOrder) { po in
                NavigationLink(destination: PODetailView(poObj: po))
                {
                    VStack {
                        Text("PO ID: \(po.id) with #\(po.items!.count) items")
                        Text("Last update: \(po.last_updated!, formatter: itemFormatter)")
                    }
                }
            }
            .onDelete(perform: deletePO)
//--------------------------------------
            Button(action: addPO) {
                Label("Add Purchase Order", systemImage: "plus")
            }
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif
        }
//--------------------------------------
    }
    
    private func addPO() {
        withAnimation {
            let lastID = Int32(purchaseOrder.first?.id ?? 0)
            dummyPO(mocContext: mocContext, lastID: lastID)
            appEnv.sharedPC.save()
        }
    }

    private func deletePO(offsets: IndexSet) {
        withAnimation {
            offsets.map { purchaseOrder[$0] }.forEach(mocContext.delete)
            appEnv.sharedPC.save()
        }
    }
    
    private func dummyPO(mocContext: NSManagedObjectContext, lastID: Int32)
    {
        let poBase = Purchase_Order(context: mocContext)
        poBase.id = lastID + 1
        poBase.last_updated = Date()
        poBase.active_flag = true
        poBase.approval_status = 2
        poBase.delivery_note = "mm"
        poBase.device_key = "mm1"
        poBase.issue_date = Date()
        poBase.last_updated = Date()
        poBase.last_updated_user_entity_id = 43
        poBase.preferred_delivery_date = Date()
        poBase.purchase_order_number = "String"
        poBase.sent_date = Date()
        poBase.server_timestamp = 449
        poBase.status = 10
        poBase.supplier_id = 20
        
        let item = Item(context: mocContext)
        item.active_flag = true
        item.created = Date()
        item.id = lastID
        item.last_updated = Date()
        item.last_updated_user_entity_id = 32
        item.ordered_quantity = 3
        item.product_item_id = 5
        item.quantity = 10
        item.transient_identifier = ": String?"
        item.puchase_orders = poBase
//        item.cancelled_purchase_orders: Purchase_Order?
        
        let invoice = Invoice(context: mocContext)
        invoice.id = lastID
        invoice.active_flag = true
        invoice.created = Date()
        invoice.invoice_number = ": String?-"
        invoice.last_updated = Date()
        invoice.last_updated_user_entity_id = 3
        invoice.receipt_sent_date = Date()
        invoice.received_status = 4
        invoice.transient_identifier = "Stringss"
        invoice.purchase_orders = poBase
//        invoice.receipts: NSSet?

        
//            poBase.cancellations: NSSet?
//            poBase.invoices: NSSet?
//        return poBase
    }
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
