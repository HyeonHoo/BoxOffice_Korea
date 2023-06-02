//
//  Movie.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/06/03.
//

import Foundation

struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Codable {
    let movieNm : String
    let audiAcc: String
    let audiCnt: String
    let openDt: String
    let movieCd: String
    let salesAcc: String
    let rank: String
}
