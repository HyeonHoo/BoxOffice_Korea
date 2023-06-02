//
//  MovieViewModel.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/06/03.
//
import Foundation

class MovieViewModel {
    private var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=30e77e7642a595f8537d082d2de83fc2&targetDt="

    var reloadData: (() -> Void)?

    private var movieData: MovieData? {
        didSet {
            reloadData?()
        }
    }

    init() {
        fetchData()
    }

    private func getData(completion: @escaping (MovieData?) -> Void) {
        movieURL += getYesterdayDate()
        guard let url = URL(string: movieURL) else {
            print("잘못된 URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("오류: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let JSONdata = data else {
                print("데이터를 받지 못했습니다")
                completion(nil)
                return
            }

            let decoder = JSONDecoder()

            do {
                let decodedData = try decoder.decode(MovieData.self, from: JSONdata)
                completion(decodedData)
            } catch {
                print("해독 오류: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }

    private func fetchData() {
        getData { movieData in
            DispatchQueue.main.async {
                self.movieData = movieData
            }
        }
    }

    var numberOfRows: Int {
        return movieData?.boxOfficeResult.dailyBoxOfficeList.count ?? 0
    }

    func movie(at index: Int) -> DailyBoxOfficeList? {
        return movieData?.boxOfficeResult.dailyBoxOfficeList[index]
    }

    private func getYesterdayDate() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: yesterday!)
    }
}
