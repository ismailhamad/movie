//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Ismail on 14/08/2022.
//

import Foundation
import Combine

class MovieViewModel:ObservableObject {
    @Published var moviesPopular:Movie?
    @Published var moviesSimiler:Movie?
    @Published var TvPopular:TVs?
    @Published var TvTopRate:TVTop?
    @Published var moviesToprate:Movie?
    private var cancellable: AnyCancellable?
    private var cancellable2 = Set<AnyCancellable>()
    private var cancellable3 = Set<AnyCancellable>()


    init(){
         fatchData()
         getTv()
        getTOPRateTV()
      //  similarMovie(idMovie: 616037)
        //getTop_rated()
    }

    
    func fatchData(){
        guard let url1 = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=cc1254940edf002b9b73d70a58a78c7e") else {return}
        guard let url2 = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=cc1254940edf002b9b73d70a58a78c7e") else {return}
      //  guard let url3 = URL(string:"https://api.themoviedb.org/3/tv/popular?api_key=cc1254940edf002b9b73d70a58a78c7e")else{return}

        let publisher1 = URLSession.shared.dataTaskPublisher(for: url1)
        
            .tryMap { (data,respone) -> Data in
                guard let respone = respone as? HTTPURLResponse,
                      respone.statusCode >= 200 && respone.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
          .decode(type: Movie.self, decoder: JSONDecoder())


        let publisher2 = URLSession.shared.dataTaskPublisher(for: url2)
            .tryMap { (data,respone) -> Data in
                guard let respone = respone as? HTTPURLResponse,
                      respone.statusCode >= 200 && respone.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
        .decode(type: Movie.self, decoder: JSONDecoder())

        self.cancellable = Publishers.Zip(publisher1, publisher2)
        .eraseToAnyPublisher()
        .catch { [self] _ in
            Just((moviesPopular!, moviesToprate!))
        }
        .receive(on: DispatchQueue.main)

        .sink (receiveValue: { [weak self] moviespopular,moviestopRate in
     
            self?.moviesPopular = moviespopular
            self?.moviesToprate = moviestopRate
        
        })
  
        
        
        
//        URLSession.shared.dataTaskPublisher(for: uri)
//            .receive(on: DispatchQueue.main)
//            .tryMap { (data,respone) -> Data in
//                guard let respone = respone as? HTTPURLResponse,
//                      respone.statusCode >= 200 && respone.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .decode(type: Movie.self, decoder: JSONDecoder())
       

        
    }
    
    func getTv(){
        guard let url3 = URL(string:"https://api.themoviedb.org/3/tv/popular?api_key=cc1254940edf002b9b73d70a58a78c7e")else{return}
  
        URLSession.shared.dataTaskPublisher(for: url3)
            .receive(on: DispatchQueue.main)
            .tryMap { (data,respone) -> Data in
                guard let respone = respone as? HTTPURLResponse,
                      respone.statusCode >= 200 && respone.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: TVs.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("completion: \(completion)")
            } receiveValue: { [weak self] movie in
             //print(movie)
                self?.TvPopular = movie
            }
            .store(in: &cancellable3)


    }
    func getTOPRateTV(){
        guard let url5 = URL(string:"https://api.themoviedb.org/3/tv/top_rated?api_key=cc1254940edf002b9b73d70a58a78c7e")else{return}

        URLSession.shared.dataTaskPublisher(for: url5)
            .receive(on: DispatchQueue.main)
            .tryMap { (data,respone) -> Data in
                guard let respone = respone as? HTTPURLResponse,
                      respone.statusCode >= 200 && respone.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: TVTop.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("completion: \(completion)")
            } receiveValue: { [weak self] movie in
                self?.TvTopRate = movie
            }
            .store(in: &cancellable3)
    }
    
    func similarMovie(idMovie:Int){
        guard let url6 = URL(string:"https://api.themoviedb.org/3/movie/\(idMovie)/similar?api_key=cc1254940edf002b9b73d70a58a78c7e")else{return}

        URLSession.shared.dataTaskPublisher(for: url6)
            .receive(on: DispatchQueue.main)
            .tryMap { (data,respone) -> Data in
                guard let respone = respone as? HTTPURLResponse,
                      respone.statusCode >= 200 && respone.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("completion: \(completion)")
            } receiveValue: { [weak self] movie in
                print(movie)
                self?.moviesSimiler = movie
            }
            .store(in: &cancellable3)
    }
}
