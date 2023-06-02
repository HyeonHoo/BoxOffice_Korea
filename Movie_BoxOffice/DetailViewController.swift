//
//  DetailViewController.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/05/30.
//

import UIKit
import WebKit


class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var movieName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movieName
                let urlKorString = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query="+movieName
                let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                guard let url = URL(string:urlString) else { return }
                let request = URLRequest(url: url)
                webView.load(request)
    }
    
    
        //    let urlKorString = "https://namu.wiki/w/"+movieName
          //  let urlKorString = "https://map.naver.com/v5/search/영화관"
        // Do any additional setup after loading the view.
        //nameLabel.text = movieName
        
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
