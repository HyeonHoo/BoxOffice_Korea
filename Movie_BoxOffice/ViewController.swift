//
//  ViewController.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/05/21.
//
import UIKit
import Foundation
import Alamofire // For network requests

// MARK: - MovieModel
struct MovieModel: Codable {
    let items: [NaverMovie]
}

// MARK: - Item
struct NaverMovie: Codable {
    let title: String
    let link: String
    let image: String
    //let subtitle, pubDate, director, actor: String
    let userRating: String
}



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
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var moviedata : MovieData?
    var movieList: [NaverMovie] = []
    
    var movieURL  = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=30e77e7642a595f8537d082d2de83fc2&targetDt=" //20230510
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "박스오피스(영화진흥위원회제공: " + getYesterdayDate() + ")"
    }
    var selectedMovieCode: String?
    var selectedMovieName: String?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        
        cell.Moviename.text =  moviedata?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        
        guard let Acc = moviedata?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc else {
            return cell
        }
        let numS = NumberFormatter()
        numS.numberStyle = .decimal
        guard let Accmulate = Int(Acc), let result = numS.string(for: Accmulate) else {
            return cell
        }
        cell.MovieAcc.text = "누적: \(result) 명"
        
        guard let openDt = moviedata?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].openDt else {
            cell.OpenDt.text = nil
            return cell
        }
        
        let formattedOpenDate = "개봉일: " + openDt
        cell.OpenDt.text = formattedOpenDate

        let MovieCode = moviedata?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieCd
        let MovieName =
            moviedata?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        
        selectedMovieCode = MovieCode
        
        selectedMovieName = MovieName
        
        // 영화 데이터를 가져와서 셀을 업데이트합니다.
        getMovieData(for: cell, at: indexPath.row)
        
        return cell
    }

    struct MovieService {
        static let shared = MovieService()
        let clientID = "ctwIeRpCU4xcbGeFbhPP"
        let clientSecret = "5gHi0m1ON9"
        let urlString = "https://openapi.naver.com/v1/search/movie.json"
        
        func fetchMovieData(movieCode: String, completion: @escaping (Result<Any, Error>) -> ()) {
            let urlStr = urlString + "?query=\(movieCode)"
            print(urlStr)
            if let url = URL(string: urlStr) {
                let session = URLSession(configuration: .default)
                
                var requestURL = URLRequest(url: url)
                requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
                requestURL.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
                
                let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if let safeData = data {
                        print(String(data: safeData, encoding: .utf8)) // 응답 데이터 출력
                        do {
                            let decodedData = try JSONDecoder().decode(MovieModel.self, from: safeData)
                            completion(.success(decodedData))
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else {
                        print("No data received")
                        completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                    }

                }
                dataTask.resume()
            }
        }
    }

    func getMovieData(for cell: MyTableViewCell?, at index: Int) {
        guard let movieCode = selectedMovieCode else {
            return
        }
        
        MovieService.shared.fetchMovieData(movieCode: movieCode) { result in
            switch result {
            case .success(let movieData):
                if let decodedData = movieData as? MovieModel {
                    self.movieList = decodedData.items
                    
                    if let cell = cell, index < self.movieList.count {
                        let userRating = self.movieList[index].userRating
                        DispatchQueue.main.async {
                            cell.MovieRt.text = "평점: \(userRating)"
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    
                    return
                }
            case .failure(let error):
                print("fail", error)
            }
        }
    }

   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        movieURL += getYesterdayDate()
        getData()
        getMovieData(for: nil, at: 0)
    }
    
    func getYesterdayDate() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // 어제의 날짜 가져오기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 원하는 날짜 형식 설정
        
        return dateFormatter.string(from: yesterday!) // 날짜를 지정된 형식으로 문자열로 변환하여 반환
    }
    
    func getData() {
        guard let url = URL(string: movieURL) else {
            print("잘못된 URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("오류: \(error.localizedDescription)")
                return
            }
            
            guard let JSONdata = data else {
                print("데이터를 받지 못했습니다")
                return
            }
            
            let dataString = String(data: JSONdata, encoding: .utf8)
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(MovieData.self, from: JSONdata)
                self.moviedata = decodedData
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch {
                print("해독 오류: \(error)")
            }
        }
        
        task.resume()
    }

}

