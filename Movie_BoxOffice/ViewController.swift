//
//  ViewController.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/05/21.
//
import UIKit
import Alamofire

// MARK: - Model
struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Codable {    //사용 API 필드 구조
    let movieNm : String    //영화이름
    let audiAcc: String     //누적관객
    let audiCnt: String     //해당일관객
    let openDt: String      //개봉일
    let movieCd: String     //영화코드
    let salesAcc: String    //누적매출액
    let rank: String        //영화 순위
}

// MARK: - ViewController
class ViewController: UIViewController {
    
    // MARK: - Properties
    var moviedata : MovieData?
    var movieURL  = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=30e77e7642a595f8537d082d2de83fc2&targetDt=" //20230510
    // TableView 생성
    @IBOutlet weak var table: UITableView! {
        didSet {
            table.delegate = self
            table.dataSource = self
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        movieURL += getYesterdayDate()
        getData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else {
            return
        }
        
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        dest.movieName = (moviedata?.boxOfficeResult.dailyBoxOfficeList[row].movieNm)!
    }
    
    // MARK: - Helper Functions
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
        
        AF.request(url).validate().responseDecodable(of: MovieData.self) { response in
            switch response.result {
            case .success(let decodedData):
                self.moviedata = decodedData
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            case .failure(let error):
                print("해독 오류: \(error)")
            }
        }
    }
}
    
    
    // MARK: - UITableViewDataSource
    extension ViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
            // 데이터를 가져와 셀에 할당합니다.
            guard let movieList = moviedata?.boxOfficeResult.dailyBoxOfficeList,
                  indexPath.row < movieList.count else {
                return cell
            }
            
            let movie = movieList[indexPath.row]
            
            cell.Moviename.text = movie.movieNm
            cell.MovieRank.text = movie.rank + "."
            
            let numSa = NumberFormatter()
            numSa.numberStyle = .decimal
            if let salesAcc = Int(movie.salesAcc),
               let result = numSa.string(for: salesAcc) {
                cell.MovieSacc.text = "누적 매출액: \(result) 원"
            }
            
            let numC = NumberFormatter()
            numC.numberStyle = .decimal
            if let audiCnt = Int(movie.audiCnt),
               let result = numC.string(for: audiCnt) {
                cell.MovieCnt.text = "오늘 관객수: \(result) 명"
            }
            
            let numS = NumberFormatter()
            numS.numberStyle = .decimal
            if let audiAcc = Int(movie.audiAcc),
               let result = numS.string(for: audiAcc) {
                cell.MovieAcc.text = "누적 관객수: \(result) 명"
            }
            
            let formattedOpenDate = "개봉일: " + movie.openDt
            cell.OpenDt.text = formattedOpenDate
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    extension ViewController: UITableViewDelegate {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "박스오피스(영화진흥위원회제공: " + getYesterdayDate() + ")"
        }
        
        func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            return "by Shin Hyeon Ho"
        }
    }

