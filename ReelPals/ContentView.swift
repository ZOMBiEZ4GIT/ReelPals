import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SubmissionScreen()
                .tabItem {
                    Label("Submit", systemImage: "square.and.pencil")
                }
            
            Text("Viewing Screen Placeholder")
                .tabItem {
                    Label("View", systemImage: "eye")
                }
        }
    }
}
