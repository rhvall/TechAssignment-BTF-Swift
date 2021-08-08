//
//  ItemEditView.swift
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

enum ItemValidationError: Error
{
    case WrongOrderedQuantity
    case WrongProductItemID
    case WrongQuantity
    case WrongContext
}

struct ValidatedItemData
{
    let orderedQuantity: Int32
    let productItemID: Int32
    let quantity: Int32
    let transientID: String
}

struct ItemEditView: View
{
    @ObservedObject var poObj: Purchase_Order
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var appEnv: AppEnvironmentData
    
    @State private var orderedQuantity: String = ""
    @State private var productItemID: String = ""
    @State private var quantity: String = ""
    @State private var transientID: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View
    {
        List
        {
            TextField("Ordered Quantity:", text: $orderedQuantity)
            TextField("Product item ID:", text: $productItemID)
            TextField("Item Quantity:", text: $quantity)
            TextField("Transient ID:", text: $transientID)
            Button("Submit", action: buttonActionSubmit)
            if (errorMessage.isEmpty == false) {
                Text("\(errorMessage)")
                    .foregroundColor(.red)
            }
            else {
                Text("").hidden()
            }
        }
    }
    
    private func buttonActionSubmit()
    {
        do {
            let validated = try verifyData()
            try storeData(po: poObj, itmData: validated)
            presentationMode.wrappedValue.dismiss()
            errorMessage = ""
        }
        catch ItemValidationError.WrongOrderedQuantity
        {
            errorMessage = "Wrong Ordered Quantity"
        }
        catch ItemValidationError.WrongProductItemID
        {
            errorMessage = "Wrong Product Item ID"
        }
        catch ItemValidationError.WrongQuantity
        {
            errorMessage = "Wrong Quantity"
        }
        catch
        {
            errorMessage = "Incorrect data"
        }
    }
    
    private func verifyData() throws -> ValidatedItemData
    {
        guard let oqInt = Int32(orderedQuantity) else
        {
            throw ItemValidationError.WrongOrderedQuantity
        }
        
        guard let pID = Int32(productItemID) else
        {
            throw ItemValidationError.WrongProductItemID
        }
        
        guard let itmQty = Int32(quantity) else
        {
            throw ItemValidationError.WrongQuantity
        }
        
        return ValidatedItemData(orderedQuantity: oqInt,
                                 productItemID: pID,
                                 quantity: itmQty,
                                 transientID: transientID)
    }
    
    private func storeData(po: Purchase_Order, itmData: ValidatedItemData) throws
    {
        guard let ctx = poObj.managedObjectContext else
        {
            throw ItemValidationError.WrongContext
        }
        
        let item = Item(context: ctx)
        item.active_flag = true
        item.created = Date()
        let count = poObj.items?.count ?? 1
        item.id = Int32(count)
        item.last_updated = Date()
        item.last_updated_user_entity_id = poObj.last_updated_user_entity_id
        item.ordered_quantity = itmData.orderedQuantity
        item.product_item_id = itmData.productItemID
        item.quantity = itmData.quantity
        item.transient_identifier = itmData.transientID
        item.puchase_orders = poObj
        poObj.addToItems(item)
        appEnv.sharedPC.save()
    }
}

struct ItemEditView_Previews: PreviewProvider
{
    static var poObj = Purchase_Order()
    static var previews: some View
    {
        ItemEditView(poObj: poObj)
    }
}
