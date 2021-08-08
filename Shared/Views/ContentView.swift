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
            NavigationLink(destination: POEditView())
            {
                Label("Add Purchase Order", systemImage: "plus")
            }
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif
        }
        .onAppear {
            if (purchaseOrder.count == 0) {
                ContentLoader.loadJSONFromNetwork(env: appEnv)
            }
        }
//--------------------------------------
    }

    private func deletePO(offsets: IndexSet) {
        withAnimation {
            offsets.map { purchaseOrder[$0] }.forEach(mocContext.delete)
            appEnv.sharedPC.save()
        }
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
