//
//  ViewController.m
//  OcProjectDemo
//
//  Created by 黄焕来 on 2022/12/7.
//

#import "ViewController.h"
#import <TMSDK/TMSDK-Swift.h>
#import "WebKit/WebKit.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()<WKNavigationDelegate>
@property(nonatomic,strong) IBOutlet WKWebView *webView;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request        = navigationAction.request;
    NSString     *scheme         = [request.URL scheme];
    NSString     *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"Current URL is %@",absoluteString);
        
    if ([scheme isEqualToString:@"weixin"]) {
        NSLog(@"微信支付跳转");
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    [wkUController addScriptMessageHandler:self name:@"loginCallback"];
    config.userContentController = wkUController;
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:@"jsBridge" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0,60,SCREEN_WIDTH,SCREEN_HEIGHT)configuration:config];
    NSURL *payUrl = [NSURL URLWithString:@"https://cdn.kuaiyugo.com/SDK/ios_web_sdk/index.html#/pay?program_id=0e60f6a1b71311ec9e1cc968ca9ce661&coin=1&goods_name=123&game_nickname=111&open_id=xh381qMrBoZchznT2Gjvm9_h5&pay_type=1&game_uid=123&program_param=test&appid=123"];//支付链接，参数值不能中文，需要encode编码
    NSURL *loginUrl = [NSURL URLWithString:@"https://cdn.kuaiyugo.com/SDK/ios_web_sdk/index.html#/?program_id=0e60f6a1b71311ec9e1cc968ca9ce661"];//登录
    
    NSURLRequest *request = [NSURLRequest requestWithURL:payUrl];
    [webView loadRequest:request];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    
    TMSDK *sdk = [[TMSDK alloc]init];
    [sdk configWithProgramId:@"0e60f6a1b71311ec9e1cc968ca9ce661" appid:@"tm035dc36fbbad5d36" channel:@"test"];//初始化
//    NSLog([sdk createOrderWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" coin:@"1" program_param:@"test" goods_name:@"test" zone:@"1" game_uid:@"123" game_nickname:@"lake" pay_type:@"1"]);
//    [sdk captchaWithPhone:@"13511111111"];//获取验证码
//    [sdk loginWithPhone:@"13511111111" verify_code:@"123456"];//登录
//    [sdk createRoleWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" trackingId:@"创角类型1" gameUserId:@"游戏id" nickname:@"昵称" zone:@"区服" level:@"玩家等级" vip_level:@"vip等级"];//创建角色
//    [sdk onlineWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" ofp:@"52f6b2e80fc7fa70c94c115273b1beeeefa1f97a"];//游戏在线
//    [sdk queryIdentifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5"];//查询实名状态
//    [sdk identifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" name:@"姓名" id_card:@"身份证号"];//实名认证
//    [sdk reportIdentifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5"];//实名信息上报
}
#pragma mark <WKScriptMessageHandler>
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary * data = message.body;
    //JS 调用 OC
    if([message.name isEqualToString:@"loginCallback"]){
        //在此处客户端得到 js 透传数据 并对数据进行后续操作
       NSLog(@"data:%@",data);
    }
    if([message.name isEqualToString:@"paySuccess"]){
        //在此处客户端得到 js 透传数据 并对数据进行后续操作
       NSLog(@"data:%@",data);
    }
    if([message.name isEqualToString:@"payCancel"]){
        //在此处客户端得到 js 透传数据 并对数据进行后续操作
       NSLog(@"data:%@",data);
    }
    if([message.name isEqualToString:@"payFail"]){
        //在此处客户端得到 js 透传数据 并对数据进行后续操作
       NSLog(@"data:%@",data);
    }
}


@end
