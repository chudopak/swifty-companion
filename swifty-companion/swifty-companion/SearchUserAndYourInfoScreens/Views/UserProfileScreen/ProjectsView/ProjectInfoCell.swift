//
//  ProjectInfoCell.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/14/22.
//

import UIKit

class ProjectInfoCell: UITableViewCell {

	static let identifier = "ProjectInfoCell"
	
	var projectData: ProjectData! {
		didSet {
			setProjectInfo()
		}
	}
	
	private lazy var name = makeLabel(textSize: 18, alignment: .left)
	private lazy var score = makeLabel(textSize: 18, alignment: .right)
	private lazy var mark = makeLabel(textSize: 18, alignment: .right)

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clear
		addSubview(name)
		addSubview(score)
		addSubview(mark)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	private func setProjectInfo() {
		name.text = projectData.projectName
		score.text = String(projectData.finalMark)
		if (projectData.validated) {
			mark.textColor = UIColor(named: "greenSuccess")
			score.textColor = UIColor(named: "greenSuccess")
			name.textColor = UIColor(named: "greenSuccess")
		} else {
			mark.textColor = UIColor(named: "redFailure")
			score.textColor = UIColor(named: "redFailure")
			name.textColor = UIColor(named: "redFailure")
		}
		mark.text = projectData.validated ? "✓" : "✗"
	}

}

extension ProjectInfoCell {
	
	private func makeLabel(textSize: CGFloat, alignment: NSTextAlignment) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1
		label.textAlignment = alignment
		label.font = UIFont.systemFont(ofSize: textSize)
		label.adjustsFontSizeToFitWidth = true
		label.text = ""
		return (label)
	}
}

extension ProjectInfoCell {
	
	private func setConstraints() {
		setNameConstraints(for: name)
		setScoreConstraints(for: score)
		setMarkConstraints(for: mark)
	}
	
	private func setNameConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: tableViewLabelsSizeOffset),
			view.widthAnchor.constraint(equalToConstant: nameLabelWidth),
			view.heightAnchor.constraint(equalToConstant: projectViewlabelsHeight),
			view.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
	private func setScoreConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -tableViewLabelsSizeOffset),
			view.widthAnchor.constraint(equalToConstant: scoreLabelWidth),
			view.heightAnchor.constraint(equalToConstant: projectViewlabelsHeight),
			view.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
	private func setMarkConstraints(for view: UIView) {
		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: name.trailingAnchor),
			view.trailingAnchor.constraint(equalTo: score.leadingAnchor),
			view.heightAnchor.constraint(equalToConstant: projectViewlabelsHeight),
			view.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
