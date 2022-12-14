//
//  LeaguesViewController.swift
//  FinalProjectITI
//
//  Created by Abdullah Elbokl on 09/08/2022.
//

import UIKit
import Alamofire


var leaguesIsEmpty: Bool! // check if there are no leagues

func classify (myData: [LeagueDataBaseModel], sportName: String)-> [LeagueDataBaseModel]{

    var temp:[LeagueDataBaseModel] = []
    for i in myData{
        if i.strSport! == sportName{
            temp.append(i)
        }
    }
    if temp.isEmpty{
        leaguesIsEmpty = true
    }else{
        leaguesIsEmpty = false
    }
    return temp
}


class LeaguesViewController: UIViewController{

    var sportName: String = ""
    var sportLeagues:[LeagueDataBaseModel] = []
    
    @IBOutlet weak var leaguesHeader: UILabel!
    @IBOutlet weak var leaguesTableView: UITableView!
    @IBOutlet weak var noLeaguesLabel: UILabel!
    @IBOutlet weak var notFoundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leaguesTableView.delegate = self
        leaguesTableView.dataSource = self
        
        sportLeagues = classify(myData: leaguesDataBase, sportName: self.sportName)
        checkIfEmpty()
        
        self.leaguesHeader.text = self.sportName + " leagues"
        self.leaguesTableView.reloadData()
        
    }
    
    func checkIfEmpty(){
        if (leaguesIsEmpty){
            self.leaguesTableView.isHidden = true
            self.notFoundImage.image = UIImage(named: "notFound")
        }else{
            self.notFoundImage.isHidden = true
            self.noLeaguesLabel.isHidden = true
        }
    }

    
    @objc func openVideo(_ sender: UIButton){
        if let urlStr = sportLeagues[sender.tag].strYoutube{
            let url = "https://" + urlStr
            UIApplication.shared.open(URL(string: url)!)
        }
    }
    
}

extension LeaguesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let leagueDetailsVC = storyboard?.instantiateViewController(withIdentifier: "leagueDetailsVC") as! LeagueDetailsViewController
        leagueDetailsVC.leagueDataBase = self.sportLeagues[indexPath.row]
        
        leagueDetailsVC.modalPresentationStyle = .fullScreen
        present(leagueDetailsVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

}

extension LeaguesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sportLeagues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaguescell") as! LeagueTableViewCell
        // title
        cell.leagueTitleTableViewCell.text = sportLeagues[idx].strLeague
        // image
        cell.leagueImageViewCell.kf.setImage(with: URL(string: sportLeagues[idx].strBadge ?? "defaultImage"))
        cell.leagueImageViewCell.layer.cornerRadius = cell.leagueImageViewCell.frame.width/2
        // video
        if let YTurl = sportLeagues[idx].strYoutube{
            cell.leagueVideoTableViewCell.tag = indexPath.row
            cell.leagueVideoTableViewCell.isEnabled = true
            if YTurl.isEmpty{
                cell.leagueVideoTableViewCell.tintColor = .systemGray5
                cell.leagueVideoTableViewCell.isEnabled = false
            }
        }else{
            cell.leagueVideoTableViewCell.tintColor = .systemGray5
            cell.leagueVideoTableViewCell.isEnabled = false
        }
        cell.leagueVideoTableViewCell.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
        

        return cell
    }


}
