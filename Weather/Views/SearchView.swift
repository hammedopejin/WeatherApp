//
//  SearchView.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                // Display search results here
                //                ForEach(searchResults, id: \.id) { result in
                //                        // Display search result
                //                        Text(result.location)
                //                        // Display weather information here
                //                    }
            }
            .navigationTitle("Search")
        }
    }
}
