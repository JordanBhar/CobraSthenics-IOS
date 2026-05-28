//
//  CobraSthenicsApp.swift
//  CobraSthenics
//
//  Created by Jordan Bhar on 2026-05-25.
//

import SwiftUI

@main
struct CobraSthenicsApp: App {

    @State private var environment = AppEnvironment.preview

    var body: some Scene {

        WindowGroup {

            AppShell()
                .environment(environment)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AppShell()
}
