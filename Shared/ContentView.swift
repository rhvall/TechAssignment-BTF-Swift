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

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.last_updated, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        List {
//--------------------------------------
            Label {
                Text("Technical Assestment")
            } icon: {
                Image(systemName: "keyboard")
                    .foregroundColor(Color.blue)
            }
            .labelStyle(VerticalLabelStyle())
            .font(.largeTitle)
//--------------------------------------
            ForEach(items) { item in
                Text("Item at \(item.last_updated!, formatter: itemFormatter)")
            }
            .onDelete(perform: deleteItems)
//--------------------------------------
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif
        }
//--------------------------------------
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.last_updated = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
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
