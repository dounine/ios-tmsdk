# SDK使用
1. 将 `lib/TMSDK.framework` 依赖包引入项目
(此包为真机编译，需要模拟器包可自行打包)
# SDK方法
**初始化**

Swift
```
import TMSDK
var sdk = TMSDK()
sdk.config(programId: "xx", appid: "tm035dc36fxxxx", channel: "test")
```
Oc
```
#import <TMSDK/TMSDK-Swift.h>
TMSDK *sdk = [[TMSDK alloc]init];
[sdk configWithProgramId:@"xx" appid:@"tm035dc36fxxxx" channel:@"test"];
```
## 获取短信验证码
Swift
```
sdk.captcha(phone: "13511111111")
```
Oc
```
[sdk captchaWithPhone:@"13511111111"];
```
**响应**
```
{"err":0,"msg":"发送成功","data":{}}
```
## 登录
verify_code/验证码

Swift
```
sdk.login(phone: "13588888888", verify_code: "123456")
```
Oc
```
[sdk loginWithPhone:@"13588888888" verify_code:@"123456"];
```
**响应**
```
{"err":0,"msg":"请求成功","data":{"token":"xh_c3c7851749a423c99cccfe8451de4acc","user_info":{"app_id":"tm035dc36fbbad5d36","open_id":"xh381qMrBoZchznT2Gjvm9_h5","union_id":"xh381qMrBoZchznT2Gjvm9_h5","nick_name":"玩家2936","avatar_url":"https://cdn.kuaiyugo.com/tianmu/cms/default_img.png","tel":"13535032936","recharged":0,"recharged_times":0,"is_new":false,"register_time":1669362036,"login_province":"广东省","login_city":"广州市","login_district":"白云区","ofp":"52f6b2e80fc7fa70c94c115273b1beeeefa1f97a"}}}
```
## 创角
trackingId/创角类型、1:创建角色， 2:进入游戏
gameUserId/游戏id

Swift
```
sdk.createRole(open_id: "xh381qMrBoZchznT2Gjvm9_h5", trackingId: "创角类型", gameUserId: "游戏id", nickname: "lake", zone: "一区", level: "4", vip_level: "10")
```
Oc
```
[sdk createRoleWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" trackingId:@"创角类型" gameUserId:@"游戏id" nickname:@"lake" zone:@"一区" level:@"4" vip_level:@"10"];
```
## 游戏在线
5秒调用一次即可
ofp/验证用户字段：在登录请后响应那里获取

Swift
```
print(sdk.online(open_id: "xh381qMrBoZchznT2Gjvm9_h5", ofp: "52f6b2e80fc7fa70c94c115273b1beeeefa1f97a"))
```
Oc
```
[sdk onlineWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" ofp:@"52f6b2e80fc7fa70c94c115273b1beeeefa1f97a"];
```
**响应**
```
{"code":0,"message":"请求成功","data":{}}
```
## 判断是否实名
Swift
```
print(sdk.queryIdentify(open_id: "xh381qMrBoZchznT2Gjvm9_h5"))
```
Oc
```
[sdk queryIdentifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5"];
```
**响应**
result为true即为实名
```
{"err":0,"data":{"result":true},"msg":"请求成功"}
```
## 实名认证
Swift
```
print(sdk.identify(open_id: "xh381qMrBoZchznT2Gjvm9_h5", name: "张三", id_card: "4521221993081954444"))
```
Oc
```
[sdk identifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5" name:@"张三" id_card:@"4521221993081954444"];
```
**响应**
```
{"err":0,"data":{"result":true},"msg":"请求成功"}
```
## 游戏登录上报
Swift
```
print(sdk.reportIdentify(open_id: "xh381qMrBoZchznT2Gjvm9_h5"))
```
Oc
```
[sdk reportIdentifyWithOpen_id:@"xh381qMrBoZchznT2Gjvm9_h5"];
```
**响应**
```
{"err":0,"data":{},"msg":"请求成功"}
```


