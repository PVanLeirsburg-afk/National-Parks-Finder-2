//
//  ParkMapView.swift
//  National Parks
//
//  Created by Pamela VanLeirsburg on 6/24/26.
//
import SwiftUI
import MapKit

struct ParkMapView: View {
    let coordinate: CLLocationCoordinate2D
    let parkName: String
    
    // Track the map's camera position centered on the park
    @State private var position: MapCameraPosition
    
    // Initialize the state directly with the passed coordinate
    init(coordinate: CLLocationCoordinate2D, parkName: String) {
        self.coordinate = coordinate
        self.parkName = parkName
        
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 50000, // Zoom level (50km)
            longitudinalMeters: 50000
        )
        _position = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $position) {
            Marker(parkName, coordinate: coordinate)
        }
        .navigationTitle("\(parkName) Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ParkMapView(
        coordinate: CLLocationCoordinate2D(latitude: 37.8488, longitude: -119.5571),
        parkName: "Yosemite National Park"
    )
}
