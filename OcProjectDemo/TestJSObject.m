//
//  TestJSObject.m
//  OcProjectDemo
//
//  Created by 黄焕来 on 2022/12/28.
//

#import <Foundation/Foundation.h>
#import "TestJSObject.h"

@implementation TestJSObject

-(void)loginCallback:(NSString *)data{
    NSLog(@"登录回调");
    dispatch_async(dispatch_get_main_queue(),^{
        self.loginCallbackBlock();
    });
}

@end
