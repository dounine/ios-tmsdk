//
//  ViewController.swift
//  SampleKitDemo
//
//  Created by Kenway Cen on 2022/11/18.
//

import UIKit
import TMSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var sdk = TMSDK()
        sdk.config(programId: "0e60f6a1b71311ec9e1cc968ca9ce661", appid: "tm035dc36fbbad5d36", channel: "test")//初始化
//        print(sdk.captcha(phone: "13511111111"))//获取验证码
//        print(sdk.login(phone: "13511111111", verify_code: "204689"))//登录
//        print(sdk.createRole(open_id: "xh381qMrBoZchznT2Gjvm9_h5", trackingId: "1", gameUserId: "abc", nickname: "lake", zone: "3", level: "4", vip_level: "4"))//创角
//        print(sdk.online(open_id: "xh381qMrBoZchznT2Gjvm9_h5", ofp: "52f6b2e80fc7fa70c94c115273b1beeeefa1f97a"))//游戏在线
//        print(sdk.queryIdentify(open_id: "xh381qMrBoZchznT2Gjvm9_h5"))//查询实名状态
//        print(sdk.identify(open_id: "xh381qMrBoZchznT2Gjvm9_h5", name: "张三", id_card: "452122199308190000"))//实名
//        print(sdk.reportIdentify(open_id: "xh381qMrBoZchznT2Gjvm9_h5"))//实名信息上报
    }


}

