//
//  NSString+Category.m
//  YYQRCode
//
//  Created by Loser on 2017/11/21.
//  Copyright © 2017年 Loser. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
- (BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}
@end
