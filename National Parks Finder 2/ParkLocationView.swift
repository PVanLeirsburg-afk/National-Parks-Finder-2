//
//  ParkLocationView.swift
//  National Parks
//
//  Created by Pamela VanLeirsburg on 6/24/26.
//
import SwiftUI
import MapKit

struct ParkLocationView: View {
    @State private var parkDetails = [ParkDetail]()
    @State private var showingAlert = false
    let parkCode: String
    let parkName: String
    let apiKey = "LqeeSHB9YmYMlijOmtUmTbJNQl9QwlYC2NYzk0p4"
    
    var body: some View {
        List(parkDetails) { detail in
            NavigationLink {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(detail.fullName)
                            .font(.headline)
                        Text("Located in: \(detail.states)").padding(.bottom)
                        
                        Text(detail.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // NavigationLink button pushing to the separate ParkMapView
                                        NavigationLink(destination: ParkMapView(coordinate: detail.coordinate, parkName: detail.fullName)) {
                                            HStack {
                                                Image(systemName: "map")
                                                Text("Open Full Map View")
                                            }
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        }
                        Spacer()
                    }
                    .padding()
                }
            } label: {
                Text("View Location & Info")
            }
        }
        .navigationTitle(parkName)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await getParkDetails()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the park details"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func getParkDetails() async {
        let query = "https://developer.nps.gov/api/v1/parks?parkCode=\(parkCode)&api_key=\(apiKey)"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(ParkDetailResponse.self, from: data) {
                    parkDetails = decodedResponse.data
                    return
                }
            }
        }
        showingAlert = true
    }
}

#Preview {
    ParkLocationView(parkCode: "yose", parkName: "Yosemite National Park")
}

struct ParkDetailResponse: Codable {
    var data: [ParkDetail]
}

struct ParkDetail: Identifiable, Codable {
    let id: String
    let fullName: String
    let states: String
    let description: String
    let latitude: String
    let longitude: String
        
    var coordinate: CLLocationCoordinate2D {
            let lat = Double(latitude) ?? 0.0
            let lon = Double(longitude) ?? 0.0
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
