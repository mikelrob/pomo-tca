//
//  PomoApp.swift
//  Pomo
//
//  Created by Mike Robinson on 02/08/2023.
//

import SwiftUI
import XCTestDynamicOverlay

@main
struct PomoApp: App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                PomoView(
                    store: .init(
                        initialState: Pomo.State(),
                        reducer: { Pomo()._printChanges() }
                    )
                )
            }
        }
    }
}
