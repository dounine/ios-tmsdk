//
//  ViewController.m
//  OcProjectDemo
//
//  Created by 黄焕来 on 2022/12/7.
//

#import "ViewController.h"
#import <TMSDK/TMSDK-Swift.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TMSDK *sdk = [[TMSDK alloc]init];
    [sdk configWithProgramId:@"0e60f6a1b71311ec9e1cc968ca9ce661" appid:@"tm035dc36fbbad5d36" channel:@"test"];//初始化
    [sdk captchaWithPhone:@"13511111111"];//获取验证码
    [sdk loginWithPhone:@"13511111111" verify_code:@"123456"];//登录
    [sdk createRoleWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" trackingId:@"创角类型1" gameUserId:@"游戏id" nickname:@"昵称" zone:@"区服" level:@"玩家等级" vip_level:@"vip等级"];//创建角色
    [sdk onlineWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" ofp:@"52f6b2e80fc7fa70c94c115273b1beeeefa1f97a"];//游戏在线
    [sdk queryIdentifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5"];//查询实名状态
    [sdk identifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" name:@"姓名" id_card:@"身份证号"];//实名认证
    [sdk reportIdentifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5"];//实名信息上报
}


@end
