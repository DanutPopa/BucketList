//
//  ContentView.swift
//  BucketList
//
//  Created by Danut Popa on 29.10.2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    enum MapMode {
        case standard, hybrid
        
        var mapStyle: MapStyle {
            switch self {
            case .standard:
                    .standard
            case .hybrid:
                    .hybrid
            }
        }
    }
    
    @State private var viewModel = ViewModel()
    @State private var mapMode = MapMode.standard
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                VStack {
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(mapMode.mapStyle)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) { newLocation in
                            viewModel.update(location: newLocation)
                        }
                    }
                    
                    Picker("Map Mode", selection: $mapMode) {
                        Text("Standard")
                            .tag(MapMode.standard)
                        
                        Text("Hybrid")
                            .tag(MapMode.hybrid)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
