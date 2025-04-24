

import Foundation
import ObjectMapper

struct Metadata : Mappable {
	var title : String?
	var description : String?
	var is_animated : Bool?
	var is_looping : Bool?
	var duration : Int?
	var has_sound : Bool?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		description <- map["description"]
		is_animated <- map["is_animated"]
		is_looping <- map["is_looping"]
		duration <- map["duration"]
		has_sound <- map["has_sound"]
	}

}
