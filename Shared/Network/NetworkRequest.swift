//
//  NetworkRequest.swift
//  BttrflCD-iOS
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

import Foundation
import CoreData

struct NetworkRequest
{
    static func urlJSON() -> URL
    {
        var config: [String: Any]?
                
        if let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                }
            } catch {
                print(error)
            }
        }

        let urlPath: String = (config?["Endpoint"] as? String) ?? "/dev/null"; // https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders
        return URL(string: urlPath)!
    }
    
    static func downloadPOJSON(url: URL, completion: @escaping (Data)-> Void)
    {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                      error == nil
            else
            {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            
            completion(dataResponse)
        }
        
        task.resume()
    }
}
