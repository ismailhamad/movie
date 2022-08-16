//
//  Movie.swift
//  MovieApp
//
//  Created by Ismail on 08/08/2022.
//

import Foundation

//struct Movie:Identifiable,Equatable {
//    var id = UUID().uuidString
//    var movieTitle:String
//    var artwork:String
//
//}
//var movies:[Movie] = [
//    Movie(movieTitle: "starwork", artwork: "1"),
//    Movie(movieTitle: "ssqsq", artwork: "2"),
//    Movie(movieTitle: "ceveve", artwork: "3"),
//    Movie(movieTitle: "jdwnldkw", artwork: "4"),
//    Movie(movieTitle: "kdnwdl", artwork: "5"),
//    Movie(movieTitle: " jnkwn", artwork: "6"),
//    Movie(movieTitle: "sooork", artwork: "7"),
//    Movie(movieTitle: "sjdwoidbork", artwork: "8")
//
//]


struct Movie: Codable {
    let page: Int?
    let results: [Result]
    let totalPages: Int?
    let totalResults: Int?

}

// MARK: - Result
struct Result: Codable,Identifiable,Equatable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language, original_title, overview: String?
    let popularity: Double?
    let poster_path, release_date, title: String
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?


}


struct TopRate: Codable {
    let page: Int?
    let results: [ResultTopRate]
    let totalPages: Int?
    let totalResults: Int?

}

// MARK: - Result
struct ResultTopRate: Codable,Identifiable,Equatable {
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let id: Int
    let original_language, original_title, overview: String?
    let popularity: Double?
    let poster_path, release_date, title: String
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?


}


struct TVs: Codable {
    let page: Int
    let results: [TvResult]
    let total_pages, total_results: Int


}

// MARK: - Result
struct TvResult: Codable,Identifiable,Equatable  {
    let backdrop_path, first_air_date: String
    let genre_ids: [Int]
    let id: Int
    let name: String
    let origin_country: [String]
    let original_language, original_name, overview: String
    let popularity: Double
    let poster_path: String
    let vote_average: Double
    let vote_count: Int


}


struct TVTop: Codable {
    let page: Int
    let results: [TvResultTopRate]
    let total_pages, total_results: Int


}

// MARK: - Result
struct TvResultTopRate: Codable,Identifiable,Equatable  {
    let backdrop_path, first_air_date: String?
    let genre_ids: [Int]
    let id: Int
    let name: String
    let origin_country: [String]
    let original_language, original_name, overview: String
    let popularity: Double
    let poster_path: String
    let vote_average: Double
    let vote_count: Int


}
