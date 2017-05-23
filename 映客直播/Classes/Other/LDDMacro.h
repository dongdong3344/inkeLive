//
//  LDDMacro.h
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 delta omni. All rights reserved.
//

#ifndef LDDMacro_h
#define LDDMacro_h


#define  SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define  SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define  RGB(X,Y,Z)      [UIColor colorWithRed:X/255.0 green:Y/255.0 blue:Z/255.0 alpha:1]

#define HOT_CYCLEIMG_API @"http://116.211.167.106/api/live/ticker"
#define HOT_LIVE_API  @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"
#define HOT_NAVTAG_API @"http://116.211.167.106/api/live/navigation?lc=0000000000000046&cc=TG0001&cv=IK3.8.40_Iphone&proto=7&idfa=C047AF92-D123-4807-BAF3-6E1D56DAB3CA&idfv=E424A702-D30D-411C-982F-BE15888E3CDA&devi=dc167cd7cc148ef2b449b8e1b29537a3e7802c01&osversion=ios_10.200000&ua=iPhone7_1&imei=&imsi=&uid=139182535&sid=20FbvbjPTcZcXJ0ehNyzi0i2KAVQBx8JBcqjPpi07s75HtXwHRE7i0&conn=wifi&mtid=43e6e1403853c354db30f3fe3c0ada97&mtxid=a45627ed145&logid=122,133,21&latitude=31.303477&interest=2&longitude=120.554634&location=&s_sg=356aeb396c41d2c94b32602d35059a2a&s_sc=100&s_st=1484226128"
#define HOT_NEAR_API @"http://120.55.238.158/api/live/near_flow?"
//http://120.55.238.158/api/live/near_flow?uid=139182535&latitude=31.278496&longitude=120.534604

#define TopUser_API @"http://120.55.238.158/api/live/users?lc=0000000000000047&cc=TG0001&cv=IK3.8.50_Iphone&proto=7&idfa=C047AF92-D123-4807-BAF3-6E1D56DAB3CA&idfv=E424A702-D30D-411C-982F-BE15888E3CDA&devi=dc167cd7cc148ef2b449b8e1b29537a3e7802c01&osversion=ios_10.200000&ua=iPhone7_1&imei=&imsi=&uid=139182535&sid=20FbvbjPTcZcXJ0ehNyzi0i2KAVQBx8JBcqjPpi07s75HtXwHRE7i0&conn=wifi&mtid=7fe6c941d44765b60ef51012560c0d77&mtxid=8c21a719c76&logid=136,133,21&start=90&count=20&id="

#ifdef DEBUG
#define LDDLog(...)  NSLog(__VA_ARGS__)//LDDLog不限制参数类型，中间用三个英文语句表示
#else
#define LDDLog(...)
#endif

#endif /* LDDMacro_h */

