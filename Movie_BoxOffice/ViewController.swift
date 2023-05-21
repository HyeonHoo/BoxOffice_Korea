//
//  ViewController.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/05/21.
//
import UIKit
import Foundation

class Movie {
    var link:String?
    var imageURL:String?
    var image:UIImage?
    var userRating:String?

    init() {

    }
}
class MoviesTableViewController: UITableViewController, XMLParserDelegate{
    let clientID        = "ctwIeRpCU4xcbGeFbhPP"    // ClientID
    let clientSecret    = "bYHTkauZBG"              // ClientSecret

    var movies:[Movie]      = []           // API를 통해 받아온 결과를 저장할 array

    var strXMLData: String?         = ""   // xml 데이터를 저장
    var currentTag: String?          = ""   // 현재 item의 element를 저장
    var currentElement: String      = ""   // 현재 element의 내용을 저장

}

struct NaverSearchResults: Codable {
    let items: [NaverMovieItem]
}

struct NaverMovieItem: Codable {
    let image: String?
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
    
    var movieURL  = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=30e77e7642a595f8537d082d2de83fc2&targetDt=" //20230510
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "박스오피스(영화진흥위원회제공: " + getYesterdayDate() + ")"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        as! MyTableViewCell
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
        
//        // 네이버 API에서 영화 이미지 가져오기
//          guard let movieCode = moviedata?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieCd else {
//              return cell
//          }
          
//          let naverAPIURL = "https://openapi.naver.com/v1/search/movie.json?query=\(movieCode)"
//
//          guard let naverURL = URL(string: naverAPIURL) else {
//              return cell
//          }
        
       

        return cell
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
    }
    
    func getYesterdayDate() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) // 어제의 날짜 가져오기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 원하는 날짜 형식 설정
        
        return dateFormatter.string(from: yesterday!) // 날짜를 지정된 형식으로 문자열로 변환하여 반환
    }
    
    
    func getData() {
        guard let url = URL(string: movieURL) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let JSONdata = data else {
                print("No data received")
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
                print(error)
            }
        }
        
        task.resume()
    }
}

