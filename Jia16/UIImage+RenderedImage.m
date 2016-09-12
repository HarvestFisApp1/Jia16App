//
//  UIImage+RenderedImage.m
//  ZJOL
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/6.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "UIImage+RenderedImage.h"

@implementation UIImage (RenderedImage)
+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size {
    
    UIImage *image = nil;
    UIGraphicsBeginImageContext(size);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0., 0., size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(UIImage*) imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
        
    UIGraphicsBeginImageContext(size);
    CGContextRef contextSd = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextSd,color.CGColor);
    CGContextFillRect(contextSd, rect);
    UIImage *imgSd = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return  imgSd;
}

@end

