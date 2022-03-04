//
//  JSONDecoder.swift
//  swifty-companion
//
//  Created by Stepan Kirillov on 3/4/22.
//

import UIKit

class CoalitionJSONDecoder {
	
	static func decodeCoalitionInfo(data: Data) -> CoalitionData? {
		var jsonData: [Any]?
		do {
			jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
//			print(jsonData)
		} catch {
			print("JSON ERROR \(error)")
			return (nil)
		}
		guard let jsonUnwrapedData = jsonData else {
			return (nil)
		}
		if (jsonUnwrapedData.count > 0) {
			guard let mainCoalition = jsonUnwrapedData[0] as? [String: Any] else {
				return (nil)
			}
			return (setProperties(mainCoalition: mainCoalition))
		} else {
			return (nil)
		}
	}
	
	static private func setProperties(mainCoalition: [String: Any]) -> CoalitionData? {
		var data = CoalitionData(name: "", image_url: "")
		guard let cover_url = mainCoalition["cover_url"] as? String else {
			return (nil)
		}
		data.image_url = cover_url
		guard let name = mainCoalition["name"] as? String else {
			return (nil)
		}
		data.name = name
		return (data)
	}
}
