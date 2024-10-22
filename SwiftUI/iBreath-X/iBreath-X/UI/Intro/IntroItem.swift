//
//  Introitem.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation

struct IntroItem {
    var title: String
    var description: String
    var image: String
    var buttonTitle: String
    
    static let introStore: [IntroItem] = [
        IntroItem(title: "Plan Your Trip", description: "Save places and book your perfect trip with Nicaragua App", image: " ", buttonTitle: "Next"),
        IntroItem(title: "Begin The Adventure", description: "Begin your Experience with Nicaragua APP alone or your family & friends", image: " ", buttonTitle: "Next"),
        IntroItem(title: "Enjoy Your Trip", description: "Enjoy the Nicaragua App packages and stay relax", image: "", buttonTitle: "Get Started"),
    ]
    
}


