//
//  ChartViewController.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/16/22.
//

import UIKit
import Charts

fileprivate let skillsNames: [String] = [
	"Adaptation & creativity",			"Algorithms & AI",				"Basics",
	"Company experience",				"DB & Data",					"Functional programming",
	"Graphics",							"Group & interpersonal",		"Imperative programming",
	"Network & system administration",	"Object-oriented programming",	"Organization",
	"Parallel computing",				"Rigor",						"Ruby",
	"Security",							"Shell",						"Technology integration",
	"Unix",								"Web"
]

fileprivate let skillsNamesCompressed: [String] = [
	"""
	Adaptation
	&
	creativity
	""",
	"""
	Algorithms
	&
	AI
	""", "Basics",
	"""
	Company
	experience
	""",
	"""
	DB
	&
	Data
	""",
	"""
	Functional
	programming
	""", "Graphics",
	"""
	Group &
	interpersonal
	""",
	"""
	Imperative
	programming
	""",
	"""
	Network
	&
	system
	administration
	""",
	"""
	Object-
	oriented
	programming
	""",	"Organization",
	"""
	Parallel
	computing
	""", "Rigor","Ruby", "Security","Shell",
	"""
	Technology
	integration
	""", "Unix", "Web"
]


struct SkillData {
	let name: String
	var level: Double
	let index: Int
}


class ChartViewController: UIViewController, ChartViewDelegate {

	let color = [
		UIColor.black,
		UIColor.green,
		UIColor.red,
		UIColor.blue
	]

	private var cursusName = ""
	
	private lazy var cursusNameLabel = makeCursusNameLabel()
	private lazy var skillsChart = makeSkillsChart()
	
	private var skills: [Skill]!
	
	private var skillsData = [SkillData]()
	
	init(skills: [Skill], cursus_name: String) {
		super.init(nibName: nil, bundle: nil)
		self.skills = skills.sorted(by: { $0.name < $1.name })
		cursusName = cursus_name
		print("Cursus name \(cursus_name) - \(String(describing: self.skills))")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		cursusNameLabel.text = "\(cursusName) Skills"
		view.addSubview(cursusNameLabel)
		view.addSubview(skillsChart)
		setConstraints()
		initSkillsData()
		setChart()
	}
	
	private func initSkillsData() {
		skillsData.reserveCapacity(skillsNames.count)
		for i in 0..<skillsNames.count {
			skillsData.append(SkillData(name: skillsNames[i], level: 0.0, index: i))
		}
		var j = 0
		for skill in skills {
			while (j < skillsData.count && skill.name != skillsData[j].name) {
				j += 1
			}
			if (j < skillsData.count && skill.name == skillsData[j].name) {
				skillsData[j].level = skill.level
			}
		}
	}
	
	private func setChart() {
		let data = RadarChartData(dataSet: createDataSet())
		skillsChart.data = data
		skillsChart.webLineWidth = 1.5
		skillsChart.innerWebLineWidth = 1.5
		skillsChart.webColor = .lightGray
		skillsChart.innerWebColor = .lightGray
		skillsChart.sizeToFit()
		
		skillsChart.yAxis.axisMinimum = 0.0
		skillsChart.yAxis.axisMaximum = 16.0
		skillsChart.yAxis.xOffset = 20.0
		skillsChart.yAxis.yOffset = 20.0
		skillsChart.yAxis.labelFont = UIFont.systemFont(ofSize: 9, weight: .medium)
		skillsChart.yAxis.labelTextColor = .white
		skillsChart.yAxis.drawTopYLabelEntryEnabled = false
		skillsChart.yAxis.labelCount = 4
		
		skillsChart.xAxis.valueFormatter = XAxisFormatter()
		skillsChart.xAxis.xOffset = 20.0
		skillsChart.xAxis.yOffset = 20.0
		skillsChart.xAxis.labelPosition = .bottom
		skillsChart.xAxis.labelFont = UIFont.systemFont(ofSize: 7, weight: .light)
		
		skillsChart.rotationEnabled = false
		skillsChart.legend.enabled = false
		skillsChart.animate(xAxisDuration: 1.5, yAxisDuration: 2.5)
	}
	
	private func createDataSet() -> RadarChartDataSet {
		var entries = [RadarChartDataEntry]()
		entries.reserveCapacity(skillsData.count)
		for skill in skillsData {
			entries.append(RadarChartDataEntry(value: skill.level))
		}
		let dataSet = RadarChartDataSet(entries: entries)
		dataSet.lineWidth = 2.5
		dataSet.colors = [UIColor(named: "skillsBorder") ?? .green]
		dataSet.fillColor = UIColor(named: "skillsFilled") ?? .green
		dataSet.fillAlpha = 0.85
		dataSet.drawFilledEnabled = true
		dataSet.drawValuesEnabled = false
		dataSet.setDrawHighlightIndicators(false)
		return (dataSet)
	}
	
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		print("chartValueSelected \(entry)")
	}
	
}

extension ChartViewController {
	
	private func makeCursusNameLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 24)
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		label.text = ""
		return label
	}
	
	private func makeSkillsChart() -> RadarChartView {
		let view = RadarChartView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return (view)
	}
}

extension ChartViewController {
	
	private func setConstraints() {
		setCursusNameLabel(for: cursusNameLabel)
		setSkillsChartConstraints(for: skillsChart)
	}
	
	private func setCursusNameLabel(for view: UILabel) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: self.view.topAnchor),
			view.heightAnchor.constraint(equalToConstant: skillsChartsCursusNameLabelHeieght),
			view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: skillsChartsSideOffset),
			view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -skillsChartsSideOffset)
		])
	}
	
	private func setSkillsChartConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: cursusNameLabel.bottomAnchor),
			view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
}

class XAxisFormatter: AxisValueFormatter {
	
	let titles = skillsNamesCompressed.map { "\($0)" }
	
	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		return (titles[Int(value) % titles.count])
	}
}

class YAxisFormatter: AxisValueFormatter {
	
	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		return ("\(Int(value))")
	}
}
