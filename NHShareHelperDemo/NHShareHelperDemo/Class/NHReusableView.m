//
//  NHReusableView.m
//  NHShareHelper
//
//  Created by neghao on 2017/3/21.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHReusableView.h"

@implementation NHReusableView

+(instancetype)loadViewFormXib{

    return [[NSBundle mainBundle] loadNibNamed:@"NHReusableView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
