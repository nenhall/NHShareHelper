//
//  ViewController.m
//  NHShareHelperDemo
//
//  Created by neghao on 17/3/25.
//  Copyright © 2017年 NegHao. All rights reserved.
//

#import "ViewController.h"
#import "NHShareCallTool.h"
#import "NHShareConfiguration.h"
#import "NHShareCell.h"
#import "NHReusableView.h"
#import "NHShareModel.h"
#import "NHFacebookCall.h"
#import "NHQQCall.h"
#import "NHWechatCall.h"
#import "NHWeiBoCall.h"
#import "FTPopOverMenu.h"

#define loadNib(nibName)  [UINib nibWithNibName:nibName bundle:nil]
#define loadImage(name)   [NSString stringWithFormat:@"NHShareResources.bundle/PlatformTheme/%@",(name)]


@interface ViewController ()<NHShareCallToolDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBSDKLoginButtonDelegate>

@property (nonatomic, strong) NSMutableArray *itemDataSource;
@property (nonatomic, copy  ) NSArray *sectionTitles;
@property (nonatomic, copy  ) NSArray *sectionList;
@property (weak, nonatomic) IBOutlet UICollectionView *listView;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (nonatomic, strong) NSMutableString *logs;


@end

@implementation ViewController
{
    NSIndexPath *_currentIndexPath;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NHShareCallTool sharedCallTool] addDelegate:self];
    
    _sectionList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"shareList" ofType:@"plist"]];
    [self.listView registerNib:loadNib(@"NHShareCell") forCellWithReuseIdentifier:@"cell"];
    [self.listView registerNib:loadNib(@"NHReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
}


- (void)loginAction:(NHItemModel *)model{
    [NHShareCallTool loginSetAppConst:model.type viewController:nil];
}

- (void)shareAction:(NHItemModel *)model view:(UIImageView *)view{
    if ([model.type isEqualToString:NHQQ]) {
        NHQQShareType type = NHQQShare_Session;
        if ([model.shareType isEqualToString:@"zone"]) {
            type = NHQQShare_Zone;
        }
        [NHQQCall sendTitle:NHShareTitle
                     urlStr:NHShareUrl
                description:NHShareDescription(@"")
              previewImgURL:NHShareImageUrl
                  shareType:type];
        
    }else if ([model.type isEqualToString:NHWechat]) {
        enum WXScene scene = WXSceneSession;
        if ([model.shareType isEqualToString:@"favorite"]) {
            scene = WXSceneFavorite;
        }else if ([model.shareType isEqualToString:@"timeline"]) {
            scene = WXSceneTimeline;
        }
        
        [NHWechatCall sendLinkURL:NHShareUrl
                          TagName:NHShareTitle
                            Title:NHShareTitle
                      Description:NHShareDescription(@"")
                       ThumbImage:[UIImage imageNamed:@"test"]
                          InScene:scene];
        
    }else if ([model.type isEqualToString:NHWeiBo]) {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]
                                                       pathForResource:@"test"
                                                       ofType:@"png"]];
        [NHWeiBoCall sendTitle:NHShareTitle
                 thumbnailData:data
                    webpageUrl:NHShareUrl];
        
    }else if ([model.type isEqualToString:NHAlibaba]) {

        [FTPopOverMenu showForSender:view
                       withMenuArray:@[@"发送文本消息",
                                       @"发送图片消息(图片链接形式)",
                                       @"发送图片消息(图片数据形式)",
                                       @"发送网页消息(缩略图链接形式)",
                                       @"发送网页消息(缩略图数据形式)"]
                           doneBlock:^(NSInteger selectedIndex)
         {
             switch (selectedIndex) {
                 case 0:
                     [NHAlibabaCall sendMessageText:NHShareTitle scene:0];
                     break;
                     
                 case 1:
                     [NHAlibabaCall sendPhotoByUrlString:NHShareImageUrl scene:0];
                     break;
                     
                 case 2:
                     [NHAlibabaCall sendPhotoByData:NHShareImageData scene:0];
                     break;
                     
                 case 3:
                     [NHAlibabaCall sendWebByUrlString:NHShareUrl
                                                 title:NHShareTitle
                                           description:NHShareTitle
                                              thumbUrl:NHShareImageUrl
                                                 scene:1];
                     break;
                     
                 case 4:
                     [NHAlibabaCall sendWebByData:NHShareImageData
                                        urlString:NHShareUrl
                                            title:NHShareTitle
                                      description:NHShareTitle
                                            scene:0];
                     break;
             }
         } dismissBlock:^{
             
         }];
        
    }else if ([model.type isEqualToString:NHFacebook]) {
        
    }else if ([model.type isEqualToString:NHTwitter]) {
        
    }else if ([model.type isEqualToString:NHGoogle]) {
        
    }
}


#pragma mark - NHShareCallToolDelegate
//请求用户信息结果
- (void)nh_wechatRequestUserinfo:(NHWechatUserinfo *)userinfo error:(NSError *)error {
    [self updateLog:[NSString stringWithFormat:@"微信用户信息:%@\n错误:%@",userinfo.nickname,error.localizedDescription]];
    //    NHTipWithMessage([NSString stringWithFormat:@"用户信息：%@\n错误：%@",userinfo.nickname,error.localizedDescription]);
}

-(void)nh_QQRequestUserinfo:(NHQQUserinfo *)userinfo error:(NSError *)error {
    [self updateLog:[NSString stringWithFormat:@"QQ用户信息:%@\n错误:%@",userinfo.nickname,error.localizedDescription]];
    //    NHTipWithMessage([NSString stringWithFormat:@"用户信息：%@--错误：%@",userinfo.nickname,error.localizedDescription]);
}

- (void)nh_weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo error:(NSError *)error {
    [self updateLog:[NSString stringWithFormat:@"微博用户信息:%@\n错误:%@",userinfo.name,error.localizedDescription]];
    //    NHTipWithMessage([NSString stringWithFormat:@"用户信息：%@--错误：%@",userinfo.name,error.localizedDescription]);
}

//登录结果
- (void)nh_loginResultAppType:(NHAppType)appType Success:(BOOL)success errorMsg:(NSString *)errorMsg {
    NSString *s = success ? @"成功" : @"失败";
    [self updateLog:[NSString stringWithFormat:@"登录结果:%@\n登录类型:%ld\n错误:%@",s,appType,errorMsg]];
}

//分享结果
- (void)nh_shareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg shareType:(NHAppType)shareType {
    if (success) {
        [self updateLog:[NSString stringWithFormat:@"分享成功: type:%ld",shareType]];
        //        NHTipWithMessage(@"分享成功");
    }else{
        [self updateLog:[NSString stringWithFormat:@"分享失败: type:%ld  error:%@",shareType,errorMsg]];
        //        NHTipWithMessage([NSString stringWithFormat:@"分享失败:%@",errorMsg]);
    }
}


- (void)updateLog:(NSString *)log{
    [self.logs appendString:[NSString stringWithFormat:@"%@\n\n",log]];
    NHNSLog(@"logs:%@",_logs);
    _logView.text = _logs;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *items = [self.itemDataSource objectAtIndex:indexPath.section];
    NHItemModel *model = [items objectAtIndex:indexPath.item];
    
    _currentIndexPath = indexPath;
    NHShareCell *cell = (NHShareCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //登录
    if ([model.action isEqualToString:@"OAuth"]) {
        [self loginAction:model];
    }
    //分享
    else if ([model.action isEqualToString:@"share"]) {
        [self shareAction:model view:cell.icon];
    }
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _sectionList.count;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *items = [self.itemDataSource objectAtIndex:section];
    return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NHShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *items = [self.itemDataSource objectAtIndex:indexPath.section];
    NHItemModel *model = [items objectAtIndex:indexPath.item];
    cell.icon.image = [UIImage imageNamed:loadImage(model.image)];
    cell.name.text = model.title;
    if ([model.type isEqualToString:@"Facebook"]) {
        FBSDKProfilePictureView *profilePic = [[FBSDKProfilePictureView alloc]
                                               initWithFrame:cell.icon.bounds];
        [cell.icon addSubview:profilePic];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NHReusableView *reusableView = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    reusableView.title.text = [self.sectionTitles objectAtIndex:indexPath.section];
    return reusableView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 35);
}


#pragma mark - initialize
- (NSMutableArray *)itemDataSource{
    if (!_itemDataSource) {
        _itemDataSource = [[NSMutableArray alloc] init];
        NSMutableArray *section = [NSMutableArray new];
        for (NSDictionary *dict in _sectionList) {
            [section addObject:[dict objectForKey:@"type"]];
            NSArray *list = [dict objectForKey:@"list"];
            NSMutableArray *items = [NSMutableArray new];
            for (NSDictionary *dict in list) {
                NHItemModel *model = [[NHItemModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [items addObject:model];
            }
            [_itemDataSource addObject:items];
        }
        _sectionTitles = section.copy;
    }
    return _itemDataSource;
}

- (NSMutableString *)logs{
    if (!_logs) {
        _logs = [[NSMutableString alloc] init];
    }
    return _logs;
}



@end
