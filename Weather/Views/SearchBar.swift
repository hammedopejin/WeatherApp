//
//  SearchBar.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
            Button(action: {
                // Perform search based on the entered text
                search(text)
            }) {
                Text("Search")
            }
        }
    }
    
    func search(_ query: String) {
        // Implement the search logic here
        // You can use the query to fetch weather data for the entered location
    }
}
