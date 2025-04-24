
import Foundation
import ObjectMapper

struct Media : Mappable {
	var id : String?
	var account_id : Int?
	var mime_type : String?
	var type : String?
	var name : String?
	var basename : String?
	var url : String?
	var ext : String?
	var width : Int?
	var height : Int?
	var size : Int?
	var metadata : Metadata?
	var created_at : String?
	var updated_at : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		account_id <- map["account_id"]
		mime_type <- map["mime_type"]
		type <- map["type"]
		name <- map["name"]
		basename <- map["basename"]
		url <- map["url"]
		ext <- map["ext"]
		width <- map["width"]
		height <- map["height"]
		size <- map["size"]
		metadata <- map["metadata"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
	}

}
