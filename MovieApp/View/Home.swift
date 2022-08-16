//
//  Home.swift
//  MovieApp
//
//  Created by Ismail on 08/08/2022.
//

import SwiftUI
import NukeUI
struct Home: View {
    @State var currentIndex:Int = 0
    @State var currentTab:String = "Films"
    @Namespace var animation
    @State var DetailMovie:Result?
    @State var DetailTV:TvResult?
    @State var showDetailView:Bool = false
    @State var currentCardSize:CGSize = .zero
    @StateObject var vm:MovieViewModel = MovieViewModel()
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
      
            ZStack{
                BGView()
                VStack {
                    NavBar()
                    if currentTab == "Films" {
                        
                        CustomCarousel(index: $currentIndex, items: vm.moviesPopular?.results ?? [],cardPadding: 150, id: \.id) { movie,cardSize in
                            
                         //   VStack{
                                LazyImage(url: URL(string: Constants.API.image+movie.poster_path))
                                 // .resizable()
                                    //.aspectRatio(1, contentMode: .fill)
                                    .frame(width: cardSize.width-10, height: cardSize.height)
                                    .matchedGeometryEffect(id: movie.id, in: animation)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .onTapGesture {
//                                        SimilerMovie = []
//                                        vm.similarMovie(idMovie: movie.id)
//                                       SimilerMovie = vm.moviesSimiler?.results
                                        currentCardSize = cardSize
                                       DetailMovie = movie
                                        withAnimation(.easeInOut){
                                            showDetailView = true
                                        }
                                    }

                   

                        }
                        .padding(.horizontal,-15)
                    .padding(.vertical)
                    } else {
                      
                            CustomCarousel(index: $currentIndex, items: vm.TvPopular?.results ?? [],cardPadding: 150, id: \.id) { movie,cardSize in
                                
                               // VStack{
                                    
                                    
                                    LazyImage(url: URL(string: Constants.API.image+movie.poster_path))
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .matchedGeometryEffect(id: movie.id, in: animation)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        .onTapGesture {
                                            currentCardSize = cardSize
                                            DetailTV = movie
                                            withAnimation(.easeInOut){
                                                showDetailView = true
                                            }
                                        }
                                    

                            .padding(.horizontal,-15)
                        .padding(.vertical)
                            
                            
                          
                        }
                
                    }

                    
                    CustomIndictor()
                    HStack{
                        Text("TopRate")
                            .font(.title3.bold())
                        Spacer()
                        Button("See More"){
                            
                        }
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing:15){
                            if currentTab == "Films"{
                                ForEach(vm.moviesToprate?.results ?? []){ movie in
                                    LazyImage(url: URL(string: Constants.API.image+movie.poster_path))
                                        
                                        //.aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 120)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            currentCardSize = CGSize(width: 300, height: 300)
                                            DetailMovie = movie
                                            withAnimation(.easeInOut){
                                                showDetailView = true
                                            }
                                        }

                                       
                                     
                                    
                                }
                            }else {
                                ForEach(vm.TvTopRate?.results ?? []){ movie in
                                    LazyImage(url: URL(string: Constants.API.image+(movie.poster_path )))
                                       // .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 120)
                                        .cornerRadius(10)

                                     
                                    
                                }
                            }
     
                        }
                        .padding()
                    }
                    
                    
                }
                .overlay(
                    ZStack{
                        if currentTab == "Films"{
                            if let movie = DetailMovie,showDetailView {
                                DetailView(movie: movie, showDetailView: $showDetailView, currentCardSize: $currentCardSize, animation: animation)
                                
                            }
                        }else{
                            if let tv = DetailTV,showDetailView {
                                DetailView( TV: tv, showDetailView: $showDetailView, currentCardSize: $currentCardSize, animation: animation)
                            }
                        }
                    }

                    
                    
                )


            }

    

    }
    
    func CustomIndictor() -> some View {
        HStack(spacing:5) {

           if currentTab == "Films"{
                if let movie = vm.moviesPopular {
                    ForEach(movie.results.indices){ index in
                        Circle()
                            .fill(currentIndex == index ? .blue : .gray.opacity(0.2))
                            .frame(width: currentIndex == index ? 10 : 6, height: currentIndex == index ? 10 : 6)
                    }
                }
            }else{
                if let Tv = vm.TvPopular {
                    ForEach(Tv.results.indices){ index in
                        Circle()
                            .fill(currentIndex == index ? .blue : .gray.opacity(0.2))
                            .frame(width: currentIndex == index ? 10 : 6, height: currentIndex == index ? 10 : 6)
                    }
                }
            }

        
        }
        .animation(.easeInOut, value: currentIndex)
    }
    
    @ViewBuilder
    func NavBar()-> some View {
        HStack(spacing:0){
            ForEach(["Films","TV"],id:\.self){ tab in
                Button {
                    withAnimation{
                        currentTab = tab
                    }
                } label: {
                    Text(tab)
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .padding(.horizontal,20)
                        .background{
                            if currentTab == tab {
                                Capsule()
                                    .fill(.regularMaterial)
                                    .environment(\.colorScheme, .dark)
                                    .matchedGeometryEffect(id: "TV", in: animation)
                            }
                        }
                }

            }
        }
        .padding()
    }
    
    @ViewBuilder
    func BGView() ->some View {
        if currentTab == "Films"{
            if let movie = vm.moviesPopular{
            GeometryReader { proxy in
                let size = proxy.size
                TabView(selection: $currentIndex) {
                        ForEach(movie.results.indices) { index in
                            LazyImage(url: URL(string: Constants.API.image+(movie.results[index].backdrop_path ?? "") ))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                                .tag(index)

                        }
                    }
     
                
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentIndex)
                let color:Color = (scheme == .dark ? .black : .white)
                LinearGradient(colors: [.black,.clear,color.opacity(0.15),color.opacity(0.5),color.opacity(0.8),color,color], startPoint: .top, endPoint: .bottom)
                Rectangle()
                    .fill(.ultraThinMaterial)
                
            }
            .ignoresSafeArea()
        }
        }else{
            if let TV = vm.TvPopular{
            GeometryReader { proxy in
                let size = proxy.size
                TabView(selection: $currentIndex) {
                    
                
                        ForEach(TV.results.indices) { index in
                            LazyImage(url: URL(string: Constants.API.image+TV.results[index].backdrop_path))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipped()
                                .tag(index)


                        }
                    }
     
                
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentIndex)
                let color:Color = (scheme == .dark ? .black : .white)
                LinearGradient(colors: [.black,.clear,color.opacity(0.15),color.opacity(0.5),color.opacity(0.8),color,color], startPoint: .top, endPoint: .bottom)
                Rectangle()
                    .fill(.ultraThinMaterial)
                
            }
            .ignoresSafeArea()
        }
        }
   
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}
