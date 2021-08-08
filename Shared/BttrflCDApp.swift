//
//  BttrflCDApp.swift
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

enum AppPageList
{
    case MainPage
    case DetailPage
    case EditPage
}

final class AppEnvironmentData: ObservableObject
{
    let sharedPC = PersistenceController.shared
    @Published var currentPage : AppPageList? = .MainPage
    @Environment(\.scenePhase) var scenePhase
}

@main
struct BttrflCDApp: App
{
    @StateObject private var appEnv = AppEnvironmentData()
    
    var body: some Scene
    {
        WindowGroup
        {
            NavigationView
            {
                ContentView()
                    // It needs to explicitely set the MOC to avoid issues
                    .environment(\.managedObjectContext, appEnv.sharedPC.context())
                    .navigationBarTitle(Text("Technical Assestment"), displayMode: .large)
            }
            // https://stackoverflow.com/questions/65316497/swiftui-navigationview-navigationbartitle-layoutconstraints-issue
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(appEnv)
            .onAppear {
                ContentLoader.loadJSONFromNetwork(env: appEnv)
            }
        }
        .onChange(of: appEnv.scenePhase) { _ in
            appEnv.sharedPC.save();
        }
    }
}
