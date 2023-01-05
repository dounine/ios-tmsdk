//
//  TestJSObject.h
//  TMSDK
//
//  Created by 黄焕来 on 2022/12/28.
//

#ifndef TestJSObject_h
#define TestJSObject_h
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSObjectProtocol <JSExport>

- (void)loginCallback:(NSString *)data;
//{
//    dispatch_async(dispatch_get_main_queue(),^{
//        self.loginCallbackBlock(data);
//    })
//    NSLog(@"%@",data);
//}

@end

@interface TestJSObject : NSObject<TestJSObjectProtocol>

@property (nonatomic,copy)void(^loginCallbackBlock)();

@end


#endif /* TestJSObject_h */
