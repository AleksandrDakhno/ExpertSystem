//
// Created by Aleksandr Dakhno on 28/08/14.
// Copyright (c) 2014 DAV. All rights reserved.
//

@interface CaseData : NSObject
@property (strong, nonatomic) NSNumber *identifier;
@property (copy, nonatomic) NSArray *answers;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *text;
@end