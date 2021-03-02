//
//  FacebookLogin+Scopes.swift
//  SocialLean
//
//  Created by Alan Ostanik on 24/02/2021.
//

import Foundation

public extension FacebookLogin {

    enum Scopes: String {
        case ads_management
        case ads_read
        case attribution_read
        case business_management
        case catalog_management
        case email
        case groups_access_member_info
        case instagram_basic
        case instagram_content_publish
        case instagram_manage_comments
        case instagram_manage_insights
        case leads_retrieval
        case pages_manage_ads
        case pages_manage_cta
        case pages_manage_instant_articles
        case pages_manage_engagement
        case pages_manage_metadata
        case pages_manage_posts
        case pages_messaging
        case pages_read_engagement
        case pages_read_user_content
        case pages_show_list
        case pages_user_gender
        case pages_user_locale
        case pages_user_timezone
        case public_profile
        case publish_to_groups
        case publish_video
        case read_insights
        case user_age_range
        case user_birthday
        case user_friends
        case user_gender
        case user_hometown
        case user_likes
        case user_link
        case user_location
        case user_photos
        case user_posts
        case user_videos
        case whatsapp_business_management
        case instagram_graph_user_media
        case instagram_graph_user_profile
    }
}
