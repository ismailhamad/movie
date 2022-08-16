//
//  DetailView.swift
//  MovieApp
//
//  Created by Ismail on 10/08/2022.
//

import SwiftUI
import NukeUI
struct DetailView: View {
    @State var movie:Result?
    var Similer:[Result]?
    var TV:TvResult?
    @State var DetailMovie:Result?
    @State var showDetailViewforSimi:Bool = false

    @Binding var showDetailView: Bool
  //  @Binding var detailMovie:Movie?
    @Binding var currentCardSize:CGSize
    @State var showDetailContent:Bool = false
    @State var offset:CGFloat = 0
    @StateObject var vm:MovieViewModel = MovieViewModel()

    var animation : Namespace.ID
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            if movie != nil {
                if vm.moviesSimiler == nil{
                    ProgressView()
                        .onAppear{
                            vm.moviesSimiler = nil
                            vm.similarMovie(idMovie: movie?.id ?? 0)
                        }
                }else{
                    VStack{
                        LazyImage(url: URL(string: Constants.API.image+(movie?.poster_path ?? "")))
                            //.aspectRatio(contentMode: .fill)
                            .frame(width: currentCardSize.width, height: currentCardSize.height)
                            .cornerRadius(15)
                            .matchedGeometryEffect(id: movie?.id, in: animation)
                        
                            Text(movie?.original_title ?? "")
                            .font(.title)
                                .fontWeight(.semibold)
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .padding(.top,8)
                        //Text(movie?.release_date ?? "")
                            
                        


                        VStack(spacing:15){
                            Text("Story Plot")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth:.infinity,alignment: .leading)
                                .padding(.top,9)
                            
                            Text(movie?.overview ?? "")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .frame(maxWidth:.infinity,alignment: .leading)
                            VStack{
                                Text("Similer movie")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth:.infinity,alignment: .leading)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing:15){
                                        ForEach(vm.moviesSimiler?.results ?? [] ) {  value in
                                        LazyImage(url: URL(string: Constants.API.image+value.poster_path))
                                            
                                           // .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 120)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                withAnimation(.easeInOut){
                                                    movie = nil
                                                    movie = value
                                                }
                                                vm.moviesSimiler = nil
                                                vm.similarMovie(idMovie: movie?.id ?? 0)
                                              
                                            }
                                        
                                    }
                                }
                                }
                            }
                            
                        }
                        .opacity(showDetailContent ? 1 : 0)
                        .offset(y:showDetailContent ? 0 : 200)
                    }
                    .padding()
                    .modifier(offsetModifier(offset: $offset))
                }
              
            
              
            }else {
                VStack{
                    LazyImage(url: URL(string: Constants.API.image+(TV?.poster_path ?? "")))
                        //.aspectRatio(contentMode: .fill)
                        .frame(width: currentCardSize.width, height: currentCardSize.height)
                        .cornerRadius(15)
                        .matchedGeometryEffect(id: TV?.id, in: animation)


                    VStack(spacing:15){
                        Text("Story Plot")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .frame(maxWidth:.infinity,alignment: .leading)
                            .padding(.top,25)
                        
                        Text(TV?.overview ?? "")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .frame(maxWidth:.infinity,alignment: .leading)
                    }
                    .opacity(showDetailContent ? 1 : 0)
                    .offset(y:showDetailContent ? 0 : 200)
                }
                .padding()
                .modifier(offsetModifier(offset: $offset))
            }

        }
        .coordinateSpace(name: "SCROLL")
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background{
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
        .onAppear{
            withAnimation(.easeInOut){
                showDetailContent = true
            }
        }
        .onChange(of: offset) { newValue in
            if newValue > 120 {
                withAnimation(.easeInOut){
                    showDetailContent = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.easeInOut){
                        showDetailView = false
                    }
                }

            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
