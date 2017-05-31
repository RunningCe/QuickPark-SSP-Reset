//
//  NKSspComplaintTag.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/1.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKSspComplaintTag : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger tagtype;
@property (nonatomic, copy) NSString *tagcontent;
@property (nonatomic, copy) NSString *tagtypeid;
@property (nonatomic, copy) NSString *complaintNo;

@end
