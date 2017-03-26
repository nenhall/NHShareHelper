//
//  NHUserinfo.h
//  NHShareHelper
//
//  Created by neghao on 2017/2/20.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHUserinfo : NSObject

@end

@interface NHQQUserinfo : NHUserinfo
@property (nonatomic , copy) NSString              * is_lost;
@property (nonatomic , copy) NSString              * figureurl;
@property (nonatomic , copy) NSString              * vip;
@property (nonatomic , copy) NSString              * is_yellow_year_vip;
@property (nonatomic , copy) NSString              * is_yellow_vip;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * ret;
@property (nonatomic , copy) NSString              * figureurl_qq_1;
@property (nonatomic , copy) NSString              * yellow_vip_level;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * figureurl_1;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * figureurl_2;
@property (nonatomic , copy) NSString              * figureurl_qq_2;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * nickname;
@end
/**
 QQ用户信息{
 city = "深圳";
 figureurl = "http://qzapp.qlogo.cn/qzapp/1105467244/351E0C7D3B1279A8FC11717C9800DE9B/30";
 "figureurl_1" = "http://qzapp.qlogo.cn/qzapp/1105467244/351E0C7D3B1279A8FC11717C9800DE9B/50";
 "figureurl_2" = "http://qzapp.qlogo.cn/qzapp/1105467244/351E0C7D3B1279A8FC11717C9800DE9B/100";
 "figureurl_qq_1" = "http://q.qlogo.cn/qqapp/1105467244/351E0C7D3B1279A8FC11717C9800DE9B/40";
 "figureurl_qq_2" = "http://q.qlogo.cn/qqapp/1105467244/351E0C7D3B1279A8FC11717C9800DE9B/100";
 gender = "男";
 "is_lost" = 0;
 "is_yellow_vip" = 0;
 "is_yellow_year_vip" = 0;
 level = 0;
 msg = "";
 nickname = "切克妖";
 province = "广东";
 ret = 0;
 vip = 0;
 "yellow_vip_level" = 0;
 }
 */


@interface NHWechatUserinfo : NHUserinfo
@property (nonatomic , copy) NSString              * openid;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , strong) NSArray             * privilege;
@property (nonatomic , copy) NSString              * language;
@property (nonatomic , copy) NSString              * headimgurl;
@property (nonatomic , copy) NSString              * unionid;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * province;
@end
/**
 {
 city = "";
 country = CN;
 headimgurl = "http://wx.qlogo.cn/mmopen/ajNVdqHZLLBXqPGmwqILQ4t8HRLaOv7uVNTCPx2czR5royJ22lvCZsjywNic5Ghv5aPia1DG5Vvx3IW5MLmxmUIA/0";
 language = "zh_CN";
 nickname = "切克妖👣🇻🇳";
 openid = "ogVstxLIFM0rGjBdRaFsO_QJGUEs";
 privilege =     (
 );
 province = "";
 sex = 0;
 unionid = "oFvPXwPQ9QwgeFDS-o3obMG24O00";
 }
 */


@class Insecurity,Status;
@interface NHWeiBoUserinfo : NHUserinfo
@property (nonatomic , copy) NSString              * mbtype;
@property (nonatomic , copy) NSString              * allow_all_comment;
@property (nonatomic , copy) NSString              * allow_all_act_msg;
@property (nonatomic , copy) NSString              * class;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * avatar_large;
@property (nonatomic , copy) NSString              * profile_image_url;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * verified_trade;
@property (nonatomic , copy) NSString              * verified_reason;
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * lang;
@property (nonatomic , copy) NSString              * idstr;
@property (nonatomic , copy) NSString              * bi_followers_count;
@property (nonatomic , copy) NSString              * follow_me;
@property (nonatomic , copy) NSString              * credit_score;
@property (nonatomic , copy) NSString              * followers_count;
@property (nonatomic , copy) NSString              * geo_enabled;
@property (nonatomic , copy) NSString              * description;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * verified_source_url;
@property (nonatomic , copy) NSString              * block_word;
@property (nonatomic , copy) NSString              * statuses_count;
@property (nonatomic , copy) NSString              * following;
@property (nonatomic , copy) NSString              * verified_type;
@property (nonatomic , copy) NSString              * avatar_hd;
@property (nonatomic , copy) NSString              * star;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * domain;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * block_app;
@property (nonatomic , copy) NSString              * online_status;
@property (nonatomic , strong) Insecurity              * insecurity;
@property (nonatomic , strong) Status              * status;
@property (nonatomic , copy) NSString              * urank;
@property (nonatomic , copy) NSString              * verified_reason_url;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * screen_name;
@property (nonatomic , copy) NSString              * verified_source;
@property (nonatomic , copy) NSString              * pagefriends_count;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * mbrank;
@property (nonatomic , copy) NSString              * favourites_count;
@property (nonatomic , copy) NSString              * user_ability;
@property (nonatomic , copy) NSString              * profile_url;
@property (nonatomic , copy) NSString              * weihao;
@property (nonatomic , copy) NSString              * ptype;
@property (nonatomic , copy) NSString              * friends_count;
@property (nonatomic , copy) NSString              * verified;
@end

@interface Insecurity :NSObject <NSCoding,NSCopying>
@property (nonatomic , copy) NSString              * sexual_content;
@end

@interface Pic_urls :NSObject
@end

@interface Hot_weibo_tags :NSObject
@end

@interface Text_tag_tips :NSObject
@end

@interface Annotations :NSObject
@property (nonatomic , copy) NSString              * client_mblogid;
@property (nonatomic , copy) NSString              * shooting;
@end

@interface Visible :NSObject <NSCoding,NSCopying>
@property (nonatomic , copy) NSString              * list_id;
@property (nonatomic , copy) NSString              * type;
@end

@interface Darwin_tags :NSObject
@end

@interface Status :NSObject <NSCoding,NSCopying>
@property (nonatomic , copy) NSString              * favorited;
@property (nonatomic , copy) NSString              * truncated;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * in_reply_to_screen_name;
@property (nonatomic , copy) NSString              * isLongText;
@property (nonatomic , copy) NSString              * is_show_bulletin;
@property (nonatomic , strong) NSArray<Pic_urls *>              * pic_urls;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * idstr;
@property (nonatomic , copy) NSString              * gif_ids;
@property (nonatomic , copy) NSString              * hasActionTypeCard;
@property (nonatomic , strong) NSArray<Hot_weibo_tags *>              * hot_weibo_tags;
@property (nonatomic , copy) NSString              * source_type;
@property (nonatomic , copy) NSString              * page_type;
@property (nonatomic , copy) NSString              * textLength;
@property (nonatomic , copy) NSString              * geo;
@property (nonatomic , strong) NSArray<Text_tag_tips *>              * text_tag_tips;
@property (nonatomic , copy) NSString              * comments_count;
@property (nonatomic , copy) NSString              * source;
@property (nonatomic , copy) NSString              * source_allowclick;
@property (nonatomic , copy) NSString              * biz_feature;
@property (nonatomic , strong) NSArray<Annotations *>              * annotations;
@property (nonatomic , copy) NSString              * positive_recom_flag;
@property (nonatomic , strong) Visible              * visible;
@property (nonatomic , copy) NSString              * in_reply_to_status_id;
@property (nonatomic , copy) NSString              * mid;
@property (nonatomic , copy) NSString              * reposts_count;
@property (nonatomic , copy) NSString              * userType;
@property (nonatomic , copy) NSString              * attitudes_count;
@property (nonatomic , strong) NSArray<Darwin_tags *>              * darwin_tags;
@property (nonatomic , copy) NSString              * mlevel;
@property (nonatomic , copy) NSString              * in_reply_to_user_id;

@end


/**
 @interface Insecurity :NSObject <NSCoding,NSCopying>
 @property (nonatomic , copy) NSString              * sexual_content;
 
 @end
 
 @interface Pic_urls :NSObject
 
 @end
 
 @interface Hot_weibo_tags :NSObject
 
 @end
 
 @interface Text_tag_tips :NSObject
 
 @end
 
 @interface Annotations :NSObject
 @property (nonatomic , copy) NSString              * client_mblogid;
 @property (nonatomic , copy) NSString              * shooting;
 
 @end
 
 @interface Visible :NSObject <NSCoding,NSCopying>
 @property (nonatomic , copy) NSString              * list_id;
 @property (nonatomic , copy) NSString              * type;
 
 @end
 
 @interface Darwin_tags :NSObject
 
 @end
 
 @interface Status :NSObject <NSCoding,NSCopying>
 @property (nonatomic , copy) NSString              * favorited;
 @property (nonatomic , copy) NSString              * truncated;
 @property (nonatomic , copy) NSString              * id;
 @property (nonatomic , copy) NSString              * created_at;
 @property (nonatomic , copy) NSString              * in_reply_to_screen_name;
 @property (nonatomic , copy) NSString              * isLongText;
 @property (nonatomic , copy) NSString              * is_show_bulletin;
 @property (nonatomic , strong) NSArray<Pic_urls *>              * pic_urls;
 @property (nonatomic , copy) NSString              * text;
 @property (nonatomic , copy) NSString              * idstr;
 @property (nonatomic , copy) NSString              * gif_ids;
 @property (nonatomic , copy) NSString              * hasActionTypeCard;
 @property (nonatomic , strong) NSArray<Hot_weibo_tags *>              * hot_weibo_tags;
 @property (nonatomic , copy) NSString              * source_type;
 @property (nonatomic , copy) NSString              * page_type;
 @property (nonatomic , copy) NSString              * textLength;
 @property (nonatomic , copy) NSString              * geo;
 @property (nonatomic , strong) NSArray<Text_tag_tips *>              * text_tag_tips;
 @property (nonatomic , copy) NSString              * comments_count;
 @property (nonatomic , copy) NSString              * source;
 @property (nonatomic , copy) NSString              * source_allowclick;
 @property (nonatomic , copy) NSString              * biz_feature;
 @property (nonatomic , strong) NSArray<Annotations *>              * annotations;
 @property (nonatomic , copy) NSString              * positive_recom_flag;
 @property (nonatomic , strong) Visible              * visible;
 @property (nonatomic , copy) NSString              * in_reply_to_status_id;
 @property (nonatomic , copy) NSString              * mid;
 @property (nonatomic , copy) NSString              * reposts_count;
 @property (nonatomic , copy) NSString              * userType;
 @property (nonatomic , copy) NSString              * attitudes_count;
 @property (nonatomic , strong) NSArray<Darwin_tags *>              * darwin_tags;
 @property (nonatomic , copy) NSString              * mlevel;
 @property (nonatomic , copy) NSString              * in_reply_to_user_id;
 
 @end
 
 @interface WHC :NSObject
 @property (nonatomic , copy) NSString              * mbtype;
 @property (nonatomic , copy) NSString              * allow_all_comment;
 @property (nonatomic , copy) NSString              * allow_all_act_msg;
 @property (nonatomic , copy) NSString              * class;
 @property (nonatomic , copy) NSString              * id;
 @property (nonatomic , copy) NSString              * avatar_large;
 @property (nonatomic , copy) NSString              * profile_image_url;
 @property (nonatomic , copy) NSString              * created_at;
 @property (nonatomic , copy) NSString              * remark;
 @property (nonatomic , copy) NSString              * verified_trade;
 @property (nonatomic , copy) NSString              * verified_reason;
 @property (nonatomic , copy) NSString              * location;
 @property (nonatomic , copy) NSString              * lang;
 @property (nonatomic , copy) NSString              * idstr;
 @property (nonatomic , copy) NSString              * bi_followers_count;
 @property (nonatomic , copy) NSString              * follow_me;
 @property (nonatomic , copy) NSString              * credit_score;
 @property (nonatomic , copy) NSString              * followers_count;
 @property (nonatomic , copy) NSString              * geo_enabled;
 @property (nonatomic , copy) NSString              * description;
 @property (nonatomic , copy) NSString              * url;
 @property (nonatomic , copy) NSString              * verified_source_url;
 @property (nonatomic , copy) NSString              * block_word;
 @property (nonatomic , copy) NSString              * statuses_count;
 @property (nonatomic , copy) NSString              * following;
 @property (nonatomic , copy) NSString              * verified_type;
 @property (nonatomic , copy) NSString              * avatar_hd;
 @property (nonatomic , copy) NSString              * star;
 @property (nonatomic , copy) NSString              * name;
 @property (nonatomic , copy) NSString              * domain;
 @property (nonatomic , copy) NSString              * city;
 @property (nonatomic , copy) NSString              * block_app;
 @property (nonatomic , copy) NSString              * online_status;
 @property (nonatomic , strong) Insecurity              * insecurity;
 @property (nonatomic , strong) Status              * status;
 @property (nonatomic , copy) NSString              * urank;
 @property (nonatomic , copy) NSString              * verified_reason_url;
 @property (nonatomic , copy) NSString              * province;
 @property (nonatomic , copy) NSString              * screen_name;
 @property (nonatomic , copy) NSString              * verified_source;
 @property (nonatomic , copy) NSString              * pagefriends_count;
 @property (nonatomic , copy) NSString              * gender;
 @property (nonatomic , copy) NSString              * mbrank;
 @property (nonatomic , copy) NSString              * favourites_count;
 @property (nonatomic , copy) NSString              * user_ability;
 @property (nonatomic , copy) NSString              * profile_url;
 @property (nonatomic , copy) NSString              * weihao;
 @property (nonatomic , copy) NSString              * ptype;
 @property (nonatomic , copy) NSString              * friends_count;
 @property (nonatomic , copy) NSString              * verified;
 
 @end
  */
