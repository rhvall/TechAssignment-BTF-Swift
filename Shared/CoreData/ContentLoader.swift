//
//  ContentLoader.swift
//  BttrflCD-iOS
//
//  Created by RH VT on 8/9/21.
//

import Foundation
import CoreData

struct ContentLoader
{
    static func loadJSONFromNetwork(env: AppEnvironmentData)
    {
        DispatchQueue.global(qos: .background).async {
            let url = NetworkRequest.urlJSON()
            NetworkRequest.downloadPOJSON(url: url) { jsonData in
                let cntx = env.sharedPC.context()
                guard let _ = try? ContentLoader.decodeJSON(type: [Purchase_Order].self, data: jsonData, cntx: cntx) else {
                    return
                }
                
                env.sharedPC.save()
            }
        }
    }
    
    static func decodeJSON<T>(type: T.Type, data: Data, cntx: NSManagedObjectContext) throws -> T?
        where T : Decodable
    {
        let decoder = JSONDecoder(context: cntx)
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let itemResult = try? decoder.decode(type, from: data)
        return itemResult
    }
}
