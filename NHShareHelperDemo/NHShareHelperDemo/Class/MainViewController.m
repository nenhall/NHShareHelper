//
//  MainViewController.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/11/28.
//  Copyright © 2017年 neghao. All rights reserved.
//

#import "MainViewController.h"
#import "NHShareModel.h"
#import "NHShareCallTool.h"
#import "NHQQCall.h"



#define loadImage(name)   [NSString stringWithFormat:@"NHShareResources.bundle/PlatformTheme/%@",(name)]


@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource,NHShareCallToolDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shareListView;
@property (nonatomic, strong) NSMutableString *logs;
@property (nonatomic, copy  ) NSArray *sectionList;
@property (nonatomic, strong) NSMutableArray *itemDataSource;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分享demo";
    [self loadCellInfo];
    self.shareListView.tableFooterView = [UIView new];

    [[NHShareCallTool sharedCallTool] addDelegate:self];

}

#pragma mark - NHShareCallToolDelegate
//请求用户信息结果
- (void)nh_wechatRequestUserinfo:(NHWechatUserinfo *)userinfo errorMsg:(NSString *)error {
    [self updateLog:[NSString stringWithFormat:@"微信用户信息:%@\n错误:%@",userinfo.nickname,error]];
    //    NHTipWithMessage([NSString stringWithFormat:@"用户信息：%@\n错误：%@",userinfo.nickname,error.localizedDescription]);
}

-(void)nh_QQRequestUserinfo:(NHQQUserinfo *)userinfo errorMsg:(NSString *)error {
    [self updateLog:[NSString stringWithFormat:@"QQ用户信息:%@\n错误:%@",userinfo.nickname,error]];
    //    NHTipWithMessage([NSString stringWithFormat:@"用户信息：%@--错误：%@",userinfo.nickname,error.localizedDescription]);
}

- (void)nh_weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo errorMsg:(NSString *)error {
    [self updateLog:[NSString stringWithFormat:@"微博用户信息:%@\n错误:%@",userinfo.name,error]];
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
    [UIImage imageNamed:@"test"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NHItemModel *model = [_itemDataSource objectAtIndex:indexPath.row];
    
    if ([model.shareAction isEqualToString:NHWeiBo]) {
        if (model.shareType == 1) {
            [NHShareCallTool loginSetAppConst:NHWeiBo viewController:nil];
        } else {
            [NHWeiBoCall sendTitle:@"分享测试" thumbnailData:UIImagePNGRepresentation([UIImage imageNamed:@"test"]) webpageUrl:nil];
        }
    }
    
    if ([model.shareAction isEqualToString:NHQQ]) {
        if (model.shareType == 1) {
            [NHShareCallTool loginSetAppConst:NHQQ viewController:nil];
        } else {
            [NHQQCall sendTitle:@"" urlStr:@"http://www.baidu.com" description:@"share test" previewImgURL:@"http://upload-images.jianshu.io/upload_images/435323-c3f8f31d6b109449.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700" shareType:NHQQShare_Session];
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *callCell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    
    if (!callCell) {
        callCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
    }
    
    NHItemModel *model = [_itemDataSource objectAtIndex:indexPath.row];
    callCell.textLabel.text = model.shareTitle;
    callCell.imageView.image = [UIImage imageNamed:loadImage(model.shareImage)];
    
    return callCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)loadCellInfo {
    _itemDataSource = [[NSMutableArray alloc] init];
    
    [_itemDataSource addCellInfo:^(NHShareModel *cellinfo) {
        cellinfo.shareTitle(@"微博登录");
        cellinfo.shareImage(@"nh_sina.png");
        cellinfo.shareAction(NHWeiBo);
        cellinfo.shareType(1);
    }];
    
    [_itemDataSource addCellInfo:^(NHShareModel *cellinfo) {
        cellinfo.shareTitle(@"微博分享");
        cellinfo.shareImage(@"nh_sina.png");
        cellinfo.shareAction(NHWeiBo);
        cellinfo.shareType(0);
    }];
    
    [_itemDataSource addCellInfo:^(NHShareModel *cellinfo) {
        cellinfo.shareTitle(@"QQ分享");
        cellinfo.shareImage(@"nh_qzone.png");
        cellinfo.shareAction(NHQQ);
        cellinfo.shareType(0);
    }];
    
    [_itemDataSource addCellInfo:^(NHShareModel *cellinfo) {
        cellinfo.shareTitle(@"QQ登录");
        cellinfo.shareImage(@"nh_qq.png");
        cellinfo.shareAction(NHQQ);
        cellinfo.shareType(1);
    }];
    
}



@end
