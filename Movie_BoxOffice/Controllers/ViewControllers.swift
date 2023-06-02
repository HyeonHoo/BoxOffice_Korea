//
//  ViewControllers.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/06/03.
//

import UIKit

class ViewControllers: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var table: UITableView!
    
    private var viewModel = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self

        viewModel.reloadData = { [weak self] in
            self?.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    // ...나머지 코드 동일
    // cellForRowAt을 새로운 viewModel 로 업데이트해주세요.


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        // 데이터를 가져와 셀에 할당합니다.
        guard let movie = viewModel.movie(at: indexPath.row) else {
            return cell
        }

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
