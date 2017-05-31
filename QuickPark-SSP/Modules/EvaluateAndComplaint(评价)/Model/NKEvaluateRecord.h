//
//  NKEvaluateRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/8.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKEvaluateRecord : NSObject

@property (nonatomic, strong) NSString* mepImg;
@property (nonatomic, strong) NSString* mepName;
@property (nonatomic, strong) NSString* mepScore;

@property (nonatomic, strong) NSString* parkingImg;
@property (nonatomic, strong) NSString* parkingName;
@property (nonatomic, strong) NSString* parkingScore;
@property (nonatomic, strong) NSString* parkingType;

@property (nonatomic, strong) NSString* apperanceStar;
@property (nonatomic, strong) NSString* apperanceTag;
@property (nonatomic, strong) NSString* talkStar;
@property (nonatomic, strong) NSString* talkTag;
@property (nonatomic, strong) NSString* actionStar;
@property (nonatomic, strong) NSString* actionTag;

@property (nonatomic, strong) NSString* safeStar;
@property (nonatomic, strong) NSString* safeTag;
@property (nonatomic, strong) NSString* indicateStar;
@property (nonatomic, strong) NSString* indicateTag;
@property (nonatomic, strong) NSString* senseStar;
@property (nonatomic, strong) NSString* senseTag;

//两个维度
@property (nonatomic, strong) NSString* parkingevaluatestar;
@property (nonatomic, strong) NSString* parkingevaluatetag;
@property (nonatomic, strong) NSString* tocarevaluatestar;
@property (nonatomic, strong) NSString* tocarevaluatetag;

//private String mepImg;
//private String mepName;
//private String mepScore;
//
//private String parkingImg;
//private String parkingName;
//private String parkingScore;
//private String parkingType;//道路，停车场
//
//private String apperanceStar;
//private String apperanceTag;//外表
//private String talkStar;
//private String talkTag;//谈吐
//private String actionStar;
//private String actionTag;//行为
//
//private String safeStar;
//private String safeTag;//安全
//private String indicateStar;
//private String indicateTag;//指示
//private String senseStar;
//private String senseTag;//感官




@end
