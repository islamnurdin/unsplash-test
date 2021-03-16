//
//  ContentView.swift
//  Unsplash Photos
//
//  Created by Macbook Pro on 15.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
        @ObservedObject var randomImages = UnsplashData()
        
        var columns = [
            GridItem(spacing: 0),
            GridItem(spacing: 0),
            GridItem(spacing: 0)
        ]
    
        @State var expand = false
        @State var search = ""
        @State var page = 1
        @State var isSearching = false

    
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    if !self.expand {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Search")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                        
                    }
               
                    Spacer(minLength: 0)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            withAnimation{
                                self.expand = true
                            }
                        }
                    
                    
                    // DISPLAY SEARCH BAR
                    if self.expand {
                        TextField("Search...", text: self.$search)
                        
                        // CLOSE BUTTON
                        
                        if self.search.count >= 3 {
                            
                            Button(action: {
                                
                                // SEARCH CONTENT
                                
                                self.randomImages.photoArray.removeAll()
                                self.isSearching = true
                                self.searchData()
                                
                            }) {
                                Text("GO")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            
                            withAnimation{
                                self.expand = false
                            }
                            
                            self.search = ""
                            if self.isSearching {
                                self.isSearching = false
                                self.randomImages.photoArray.removeAll()
                                self.randomImages.loadData()
                                
                            }
                            
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.leading,10)
                    }
                }
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding()
                .background(Color.white)
                
                if randomImages.photoArray.isEmpty {
                    
                    // NO PHOTOS
                    ProgressBar()
                    
                } else {
                    if self.isSearching {
                        ScrollView{
                            LazyVStack(alignment: .leading){
                                ForEach(self.randomImages.photoArray, id: \.id) { photo in
                                    
                                    WebImage(url: URL(string: photo.urls["thumb"]!))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width - 50, height: 200, alignment: .center)
                                        .cornerRadius(15) // change
                                        .onTapGesture {
                                            
                                        }
                                }.padding()
                            }
                            
                            // PAGINATION
                            
                            if !self.randomImages.photoArray.isEmpty {
                                if self.isSearching && self.search != "" && self.page < 10 {
                                    
                                    HStack{
                                        Text("Page \(self.page)")
                                        
                                        Spacer()
                                        
                                        
                                        Button(action: {
                                            
                                            self.randomImages.photoArray.removeAll()
                                            self.page += 1
                                            self.searchData()
                                            
                                        }) {
                                            Text("Next")
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(.horizontal, 25)
                              
                                } else {
                                    HStack{
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation{
                                                self.expand = false
                                            }
                                            self.randomImages.photoArray.removeAll()
                                            self.isSearching = false
                                            self.search = ""
                                            self.randomImages.loadData()
                                            
                                        }) {
                                            Text("Next")
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                }
                            }
                        }

                    } else {
                        ScrollView{
                            LazyVGrid(columns: columns){
                                ForEach(self.randomImages.photoArray, id: \.id) { photo in
                                    
                                    WebImage(url: URL(string: photo.urls["thumb"]!))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(15) // change
                                        .onTapGesture {
                                            
                                        }
                                }.padding()
                            }
                            
//                            PAGINATION
                            if !self.randomImages.photoArray.isEmpty {
                                if self.isSearching == false && self.search == "" && self.page < 10 {
                                    
                                    HStack{
                                        Text("Page \(self.page)")
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            self.randomImages.photoArray.removeAll()
                                            self.page+=1
                                            self.randomImages.loadData()
                                            
                                        }) {
                                            Text("Next")
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(.horizontal, 25)
                              
                                } else {
                                    
                                    // REMOVE DATA AND DISPLAY A PROGRESS BAR
                                    HStack{
                                        Spacer()
                                        
                                        Button(action: {
                                        
                                            self.randomImages.photoArray.removeAll()
                                            ProgressBar()
                                            
                                        }) {
                                            Text("Next")
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                }
                            }
                        }

                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            
        }
    
    func searchData(){
        let key = "4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
        let query = self.search.replacingOccurrences(of: " ", with: "%20")
        
        
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&per_page=30&query=\(query)&client_id=\(key)"
        
        self.randomImages.searchData(url: url)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// PROGRESS BAR

struct ProgressBar: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
         
    }
}
