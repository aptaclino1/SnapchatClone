//
//  TabVC.swift
//  SnapchatClone
//
//  Created by Messiah on 11/14/23.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove default tab bar border and background
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = .white

        // Create and add a circular background view
        let circularBackground = CircularBackground(frame: tabBar.bounds)
        circularBackground.backgroundColor = .clear
        tabBar.addSubview(circularBackground)
        tabBar.sendSubviewToBack(circularBackground)
    

        // Create and add a floating item bar
        let floatingItemBar = FloatingItemBar(frame: tabBar.bounds, itemCount: 4, tabBarController: self)
        tabBar.addSubview(floatingItemBar)
        tabBar.bringSubviewToFront(floatingItemBar)

        // Customize your tab bar items as needed
        let item1 = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), selectedImage: nil)
        let item2 = UITabBarItem(title: nil, image: UIImage(named: "chatfill1"), selectedImage: nil)
        let item3 = UITabBarItem(title: nil, image: UIImage(systemName: "photo.fill")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
        let item4 = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)

        viewControllers?[0].tabBarItem = item1
        viewControllers?[1].tabBarItem = item2
        viewControllers?[2].tabBarItem = item3
        viewControllers?[3].tabBarItem = item4
    }
}

class CircularBackground: UIView {

    override func draw(_ rect: CGRect) {
        // Draw a circular background
        let path = UIBezierPath(ovalIn: bounds)
        UIColor.systemBackground.setFill()
        path.fill()
    }
}

class FloatingItemBar: UIView {

    var itemCount: Int
    var tabBarController: UITabBarController?

    init(frame: CGRect, itemCount: Int, tabBarController: UITabBarController) {
        self.itemCount = itemCount
        self.tabBarController = tabBarController
        super.init(frame: frame)

        // Customize your floating item bar appearance
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = frame.height / 2

        // Create and add individual item buttons
        for i in 0..<itemCount {
            let itemButton = UIButton(type: .custom)
            itemButton.frame = CGRect(x: CGFloat(i) * frame.width / CGFloat(itemCount), y: 0, width: frame.width / CGFloat(itemCount), height: frame.height)
            itemButton.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
            addSubview(itemButton)
        }
    }

    @objc private func itemTapped(_ sender: UIButton) {
        // Handle item tap
        // You can switch the selected tab or perform any action based on the tapped item
        if let tabBarController = tabBarController, sender.tag < itemCount {
            tabBarController.selectedIndex = sender.tag
        }

        // Change the image from normal to filled
        if let itemButton = sender as? UIButton {
            let imageName: String
            switch itemButton.tag {
            case 0:
                imageName = itemButton.isSelected ? "house.fill" : "house"
            case 1:
                imageName = itemButton.isSelected ? "chatfill1" : "chat1"
            case 2:
                imageName = itemButton.isSelected ? "photo.fill" : "photo"
            case 3:
                imageName = itemButton.isSelected ? "gearshape.fill" : "gearshape"
            default:
                return
            }

            let newImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal)
            itemButton.setImage(newImage, for: .normal)

            // Toggle the selected state
            itemButton.isSelected.toggle()
        }

        print("Item tapped: \(sender.tag)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
