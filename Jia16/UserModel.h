//
//  UserModel.h
//  Jia16
//
//  Created by Ares on 16/8/5.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel :NSObject


@property(nonatomic,copy) NSString  *userId;
@property(nonatomic,copy) NSString  *createdAt;
@property(nonatomic,assign) BOOL    isBind;

@end
