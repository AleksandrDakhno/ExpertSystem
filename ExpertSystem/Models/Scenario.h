//
// Created by Aleksandr Dakhno on 28/08/14.
// Copyright (c) 2014 DAV. All rights reserved.
//

@interface Scenario : NSObject
@property (nonatomic, strong) NSNumber *caseId;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, copy) NSString *text;
@end