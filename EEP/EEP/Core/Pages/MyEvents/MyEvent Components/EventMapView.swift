//
//  EventMapView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI
import MapKit

struct EventMapView: View {
    let address: String
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var isLoading = true
    @State private var geocodeError = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: [])
                .frame(width: 350, height: 140)
                .cornerRadius(10)
            
            if !isLoading && !geocodeError {
                VStack {
                    Spacer()
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                        )
                    Spacer()
                }
                .frame(width: 350, height: 140)
            }
            
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                    .frame(width: 350, height: 140)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            } else if geocodeError {
                VStack {
                    Image(systemName: "mappin.slash")
                        .foregroundColor(.gray)
                    Text("Location not found")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 350, height: 140)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .onAppear {
            geocodeAddress()
        }
    }
    
    private func geocodeAddress() {
        guard !address.isEmpty else {
            isLoading = false
            geocodeError = true
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    geocodeError = true
                    return
                }
                
                if let placemark = placemarks?.first,
                   let location = placemark.location {
                    geocodeError = false
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                } else {
                    geocodeError = true
                }
            }
        }
    }
}

