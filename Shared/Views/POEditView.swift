//
//  POEditView.swift
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
import CoreData

enum POValidationError: Error
{
    case WrongApprovalStatus
    case WrongSupplierID
}

struct ValidatedPOData
{
    let approvalStatus: Int16
    let deliveryNote: String
    let deviceKey: String
    let poNumber: String
    let supplierID: Int32
}

struct POEditView: View
{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var appEnv: AppEnvironmentData
    
    @State private var approvalStatus: String = ""
    @State private var deliveryNote: String = ""
    @State private var deviceKey: String = ""
    @State private var poNumber: String = ""
    @State private var supplierID: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View
    {
        List
        {
            TextField("Approval Status:", text: $approvalStatus)
            TextField("Delivery Note:", text: $deliveryNote)
            TextField("Device Key:", text: $deviceKey)
            TextField("PO #:", text: $poNumber)
            TextField("Supplier ID:", text: $supplierID)
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
            try storeData(poData: validated)
            presentationMode.wrappedValue.dismiss()
            errorMessage = ""
        }
        catch POValidationError.WrongApprovalStatus
        {
            errorMessage = "Wrong Approval Status"
        }
        catch POValidationError.WrongSupplierID
        {
            errorMessage = "Wrong Supplier ID"
        }
        catch
        {
            errorMessage = "Incorrect data"
        }
    }
    
    private func verifyData() throws -> ValidatedPOData
    {
        guard let oqInt = Int16(approvalStatus) else
        {
            throw ItemValidationError.WrongOrderedQuantity
        }
        
        guard let pID = Int32(supplierID) else
        {
            throw ItemValidationError.WrongProductItemID
        }
        
        return ValidatedPOData(approvalStatus: oqInt,
                               deliveryNote: deliveryNote,
                               deviceKey: deviceKey,
                               poNumber: poNumber,
                               supplierID: pID)
    }
    
    private func storeData(poData: ValidatedPOData) throws
    {
        let context = appEnv.sharedPC.context()
        let poFetch: NSFetchRequest<Purchase_Order> = NSFetchRequest(entityName: "Purchase_Order")
        let lastID = (try? context.count(for: poFetch)) ?? 0
        let poBase = Purchase_Order(context: context)
        poBase.id = Int32(lastID + 1)
        poBase.last_updated = Date()
        poBase.active_flag = true
        poBase.approval_status = poData.approvalStatus
        poBase.delivery_note = poData.deliveryNote
        poBase.device_key = poData.deviceKey
        poBase.issue_date = Date()
        poBase.last_updated = Date()
        poBase.last_updated_user_entity_id = 43
        poBase.preferred_delivery_date = Date()
        poBase.purchase_order_number = poData.poNumber
        poBase.sent_date = Date()
        poBase.server_timestamp = 449
        poBase.status = 10
        poBase.supplier_id = poData.supplierID
        appEnv.sharedPC.save()
    }
}

struct POEditView_Previews: PreviewProvider
{
    static var previews: some View
    {
        POEditView()
    }
}
