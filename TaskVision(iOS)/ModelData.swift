//
//  ModelData.swift
//  ARApp-wAR2
//
//  Created by Abhilekh Borah on 30/08/23.
//

import SwiftUI

struct ModelData: Identifiable {
    let id = UUID()
    var imageName: String
    var title: String
    
}
var modelItem = [

    ModelData(imageName: "cup_saucer_set", title: "Break"),
    ModelData(imageName: "sneaker_pegasustrail", title: "Run"),
    ModelData(imageName: "chair_swan", title: "Sit"),
    ModelData(imageName: "slide", title: "Play"),
    ModelData(imageName: "robot_walk_idle", title: "Learn")
    
]
