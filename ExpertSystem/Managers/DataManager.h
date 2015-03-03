//
//  DataManager.h
//  ExpertSystem
//
//  Created by Aleksandr Dakhno on 28/08/14.
//  Copyright (c) 2014 DAV. All rights reserved.
//

@class CaseData;

@interface DataManager : NSObject
+ (instancetype)instance;
- (void)requestScenariousListWithCompletion:(void (^)(NSArray *scenariousList, NSError *error))completion;
- (void)requestCaseWithId:(NSNumber *)identifier completion:(void (^)(CaseData *caseData, NSError *error))completion;

- (void)loadImageForURL:(NSString *)urlString withCompletion:(void (^)(UIImage *image, NSError *error))completion;
@end
