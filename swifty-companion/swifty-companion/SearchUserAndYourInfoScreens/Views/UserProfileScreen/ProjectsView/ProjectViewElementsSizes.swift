//
//  ProjectViewElementsSizes.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/14/22.
//

import UIKit

let nameLabelWidth: CGFloat = (UIScreen.main.bounds.size.width - tableViewLabelsSizeOffset * 2) * 0.8

let scoreLabelWidth: CGFloat = (UIScreen.main.bounds.size.width - tableViewLabelsSizeOffset * 2) * 0.10

let tableViewLabelsSizeOffset: CGFloat = 16
let projectViewlabelsHeight: CGFloat = 30

let projectsScrollViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.45

let projectsViewNoProjectsLabelHeight: CGFloat = 60
let projectsViewNoProjectsLabelTopAnchorOffset: CGFloat = projectsScrollViewHeight / 2 - projectsViewNoProjectsLabelHeight / 2
