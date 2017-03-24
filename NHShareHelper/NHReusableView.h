//
//  NHReusableView.h
//  NHShareHelper
//
//  Created by neghao on 2017/3/21.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;


+(instancetype)loadViewFormXib;
@end
