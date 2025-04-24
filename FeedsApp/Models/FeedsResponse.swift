

import Foundation
import ObjectMapper

protocol FeedsResponseType {
    
}

struct FeedsResponse : Mappable, Identifiable, FeedsResponseType {
	var id : String?
	var account_id : Int?
	var title : String?
	var seo_title : String?
	var description : String?
	var view_count : Int?
	var upvote_count : Int?
	var downvote_count : Int?
	var point_count : Int?
	var image_count : Int?
	var comment_count : Int?
	var favorite_count : Int?
	var virality : Int?
	var score : Int?
	var in_most_viral : Bool?
	var is_album : Bool?
	var is_mature : Bool?
	var cover_id : String?
	var created_at : String?
	var updated_at : String?
	var url : String?
	var privacy : String?
	var vote : String?
	var favorite : Bool?
	var is_ad : Bool?
	var ad_type : Int?
	var ad_url : String?
	var include_album_ads : Bool?
	var shared_with_community : Bool?
	var is_pending : Bool?
	var platform : String?
	var media : [Media]?
	var display : [String]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		account_id <- map["account_id"]
		title <- map["title"]
		seo_title <- map["seo_title"]
		description <- map["description"]
		view_count <- map["view_count"]
		upvote_count <- map["upvote_count"]
		downvote_count <- map["downvote_count"]
		point_count <- map["point_count"]
		image_count <- map["image_count"]
		comment_count <- map["comment_count"]
		favorite_count <- map["favorite_count"]
		virality <- map["virality"]
		score <- map["score"]
		in_most_viral <- map["in_most_viral"]
		is_album <- map["is_album"]
		is_mature <- map["is_mature"]
		cover_id <- map["cover_id"]
		created_at <- map["created_at"]
		updated_at <- map["updated_at"]
		url <- map["url"]
		privacy <- map["privacy"]
		vote <- map["vote"]
		favorite <- map["favorite"]
		is_ad <- map["is_ad"]
		ad_type <- map["ad_type"]
		ad_url <- map["ad_url"]
		include_album_ads <- map["include_album_ads"]
		shared_with_community <- map["shared_with_community"]
		is_pending <- map["is_pending"]
		platform <- map["platform"]
		media <- map["media"]
		display <- map["display"]
	}

}
