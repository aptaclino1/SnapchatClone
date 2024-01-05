//
//  ReelsVC.swift
//  SnapchatClone
//
//  Created by Messiah on 1/5/24.
//
import AVKit
import UIKit

class ReelsVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var reels: [Reel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        collectionView.backgroundColor = .clear
        fetchPexelsVideos()

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
    }

    func fetchPexelsVideos() {
        
        let apiKey = "Zm9TmFXsoIRt6MTWBiuMBGpcmcoNZmrfUARU3ICecQDlVE5EJGDQO2dT"

        let url = URL(string: "https://api.pexels.com/videos/popular")!
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching Pexels videos: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let pexelsResponse = try JSONDecoder().decode(PexelsResponse.self, from: data)
                let pexelsVideos = pexelsResponse.videos

                self.reels = pexelsVideos.map {
                    Reel(id: "\($0.id)", videoTitle: $0.url, videoURL: $0.video_files.first?.link)
                }

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding Pexels response: \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension ReelsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCell", for: indexPath) as? ReelsCell else {
            fatalError("Unable to dequeue ReelsCell")
        }
       
        let reel = reels[indexPath.item]
        cell.configure(with: reel)
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedReel = reels[indexPath.item]
        presentPlayerViewController(with: selectedReel)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? ReelsCell }

       
        for cell in visibleCells {
            cell.play()
        }
    }

    func presentPlayerViewController(with reel: Reel) {
       
    }
}

