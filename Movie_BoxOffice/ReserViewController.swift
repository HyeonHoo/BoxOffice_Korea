//
//  ReserViewController.swift
//  Movie_BoxOffice
//
//  Created by 신현호 on 2023/06/02.
//

import UIKit
import WebKit

class ReserViewController: UIViewController {

    @IBOutlet weak var WebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlKorString = "https://www.megabox.co.kr/"
        //let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string:urlKorString) else { return }
        let request = URLRequest(url: url)
        WebView.load(request)


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
