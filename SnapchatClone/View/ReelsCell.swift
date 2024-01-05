//
//  ReelsCell.swift
//  SnapchatClone
//
//  Created by Messiah on 11/29/23.
//

import AVFoundation
import UIKit
import WebKit

class ReelsCell: UICollectionViewCell {
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    var webView: WKWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupWebView()
    }

    private func setupWebView() {
        webView = WKWebView(frame: videoPlayerView.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: videoPlayerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: videoPlayerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: videoPlayerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor)
        ])
    }

    func configure(with reel: Reel) {
     
        titleLabel.text = "Sample \(reel.id)"
        titleLabel.font = UIFont(name: "Avenir-BlackOblique", size: 19)
        titleLabel.textColor = .gray
    
        guard let videoURL = reel.videoURL else {
            print("Invalid video URL for \(reel.videoTitle)")
            return
        }

        let embedCode = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        </head>
        <body style="margin:0; display:flex; align-items:center; justify-content:center;">
        <div style="position: absolute; top: 50%; transform: translateY(-50%); z-index: 1; color: white; font-size: 24px; text-align: center;"></div>
        <iframe src="\(videoURL)"
                width="100%"
                height="100%"
                frameborder="0"
                webkitallowfullscreen
                mozallowfullscreen
                allowfullscreen
                style="position:absolute;top:0;left:0;width:100%;height:100%;"
                autoplay
        ></iframe>
        </body>
        </html>
        """

        webView.loadHTMLString(embedCode, baseURL: nil)
    }


    func play() {

    }

    func stop() {
 
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        webView.loadHTMLString("", baseURL: nil)
    }
}

