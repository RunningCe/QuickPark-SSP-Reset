//
//  NKQpParkingDto.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/27.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKQpParkingDto : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *parkingno;
@property (nonatomic, strong) NSString *parkingname;
@property (nonatomic, strong) NSString *companyfullname;
@property (nonatomic, assign) NSInteger parkinguserid;
@property (nonatomic, assign) NSInteger areaid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latiude;
@property (nonatomic, strong) NSString *legalperson;
@property (nonatomic, strong) NSString *legalid;
@property (nonatomic, strong) NSString *legalmobile;
@property (nonatomic, strong) NSString *legaltelephone;
@property (nonatomic, strong) NSString *legalemail;
@property (nonatomic, strong) NSString *managername;
@property (nonatomic, strong) NSString *managerid;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) float square;
@property (nonatomic, assign) NSInteger berth;
@property (nonatomic, assign) NSInteger motorvehiclelotsnum;
@property (nonatomic, assign) NSInteger nonmotorvehiclelotsnum;
@property (nonatomic, assign) NSInteger outdoorberth;
@property (nonatomic, assign) NSInteger insideberth;
@property (nonatomic, assign) NSInteger solidberth;
@property (nonatomic, assign) NSInteger internalberth;
@property (nonatomic, assign) NSInteger scheduledtotal;
@property (nonatomic, assign) NSInteger structtype;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, assign) NSInteger offersubject;
@property (nonatomic, assign) NSInteger feemode;
@property (nonatomic, assign) NSInteger classtype;
@property (nonatomic, strong) NSString *subtype;
@property (nonatomic, assign) NSInteger nature;
@property (nonatomic, strong) NSString *quasicartype;
@property (nonatomic, assign) NSInteger parkingstate;
@property (nonatomic, strong) NSDate *creattime;
@property (nonatomic, strong) NSDate *modifytime;
@property (nonatomic, assign) NSInteger samleparking;
@property (nonatomic, assign) NSInteger daduidepartmentid;
@property (nonatomic, strong) NSString *daduidepartmentname;
@property (nonatomic, assign) NSInteger distanceSort;

@property (nonatomic, strong) NSString *rinternal;
@property (nonatomic, strong) NSString *internal;
@property (nonatomic, strong) NSString *sheduled;
@property (nonatomic, strong) NSString *rscheduled;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *empty;



@end
/*
 private Integer id;
 private String parkingno;//停车场编号,唯一、不可修改
 private String parkingname;//停车场名
 private String companyfullname;//公司完整名：申办单位；关联停车场用户表中的公司名称
 private Integer parkinguserid;//停车场运营商登录用户id
 private Integer areaid;//对应于区域表的街道ID
 private String address;//停车场所在地址
 private Float longitude;//停车场所处经度
 private Float latiude;//停车场所处纬度
 private String legalperson;//单位法人
 private String legalid;//单位法人身份证号码
 private String legalmobile;//法人手机号码
 private String legaltelephone;//法人电话
 private String legalemail;//法人Email
 private String managername;//停车场责任人
 private String managerid;//停车场责任人身份证号码
 private String mobile;//停车场责任人手机号码
 private String telephone;//停车场责任人电话
 private String email;//停车场责任人Email
 private Float square;//停车场面积(平方米)
 private Integer berth;//总车位数量
 private Integer motorvehiclelotsnum;//'机动车车位数
 private Integer nonmotorvehiclelotsnum;//非机动车车位数
 private Integer outdoorberth;//露天车位数量
 private Integer insideberth;//室内车位数量
 private Integer solidberth;//立体机械车位数量
 private Integer internalberth;//总内部使用的泊位数量(私有泊位数)
 private Integer scheduledtotal;//总可预定的车位数
 private Integer structtype;//结构形式：0露天，1室内，2露天、室内混合，3多层
 private Integer quality;//土地性质：0、国有 ,1、非国有,2、部分国有
 private Integer offersubject;//开办主体：0政府投资办(国有资产投办)，1企、事业自办，2合办，3租用场地办
 private Integer feemode;//收费方式：0自动、1人工、2混合、3免费
 private Integer classtype;//类别：0社会公共类、1住宅类、2临时类、3道路停车泊位
 private String subtype;//社会公共类：00宾馆、酒家,01商业大厦,02写字楼,03专业场,04工业仓库、物流园区,05码头、口岸、车站,06旅游景点,07医院、博物馆、图书馆；住宅类：10多高层住宅区，11混合型住宅区；临时类：20临时场地，21其它场地，22路内场地；30车行道，31人行道
 private Integer nature;//停车场性质：0永久场；1临时场
 private String quasicartype;//准停车型：多个以逗号分开
 private Integer parkingstate;//状态:-1:已删除：0:新建（草稿）状态；5:备案审核不通过;10:备案审核中；20:建设中；25:验收不通过;30:验收中；80:注销；90：停业整顿中;100:运营中',
 private Date creattime;//记录的创建时间yyyy-MM-dd HH:mm:SS
 private Date modifytime;//最后修改时间yyyy-MM-dd HH:mm:SS
 private Integer samleparking;//是否是简易停车场：0：不是，1是。（简易停车场只有基本信息，而且是免费场）
 private Integer daduidepartmentid;//停车场所属大队部门ID，用于审批的数据权限控制
 private String daduidepartmentname;//停车场所属大队部门名称
 private Integer distanceSort;
 =====精致停车场实时状态=====
private String rinternal;	//内部空车位数
private String internal;	//内部总车位数
private String sheduled;	//总可预定车位数
private String rscheduled;	//空可预定车位数
private String total;	//总车位数
private String empty;	//总空车位数
*/
