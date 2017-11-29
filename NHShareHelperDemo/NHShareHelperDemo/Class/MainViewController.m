//
//  MainViewController.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/11/28.
//  Copyright © 2017年 neghao. All rights reserved.
//

#import "MainViewController.h"
#import "NHShareCallTool.h"
#import "NHShareModel.h"


#define loadImage(name)   [NSString stringWithFormat:@"NHShareResources.bundle/PlatformTheme/%@",(name)]


@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
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
    [NHWeiBoCall sendTitle:@"" thumbnailData:nil webpageUrl:@""];


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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NHItemModel *model = [_itemDataSource objectAtIndex:indexPath.row];
    if ([model.shareAction isEqualToString:NHWeiBo]) {
        [NHShareCallTool loginSetAppConst:NHWeiBo viewController:nil];
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
    }];
    
    [_itemDataSource addCellInfo:^(NHShareModel *cellinfo) {
        cellinfo.shareTitle(@"微博分享");
        cellinfo.shareImage(@"nh_sina.png");
        cellinfo.shareAction(NHWeiBo);
    }];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
