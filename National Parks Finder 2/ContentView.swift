//
//  ContentView.swift
//  National Parks Finder App 2
//
//  Created by Pamela VanLeirsburg on 6/24/26.
//
import SwiftUI

struct ContentView: View {
    @State private var parks = [ParkSummary]()
    @State private var showingAlert = false
    let apiKey = "LqeeSHB9YmYMlijOmtUmTbJNQl9QwlYC2NYzk0p4"
    
    var body: some View {
        NavigationView {
            List(parks, id: \.parkCode) { park in
                NavigationLink(destination: ParkLocationView(parkCode: park.parkCode, parkName: park.fullName)) {
                    Text(park.fullName)
                }
            }
            .navigationTitle("National Parks")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await getParks()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the national parks"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func getParks() async {
        let query = "https://developer.nps.gov/api/v1/parks?limit=50&api_key=\(apiKey)"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(ParksResponse.self, from: data) {
                    parks = decodedResponse.data
                    return
                }
            }
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}

struct ParksResponse: Codable {
    var data: [ParkSummary]
}

struct ParkSummary: Codable {
    let fullName: String
    let parkCode: String
}
