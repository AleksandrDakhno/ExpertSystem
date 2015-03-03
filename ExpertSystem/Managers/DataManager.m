//
//  DataManager.m
//  ExpertSystem
//
//  Created by Aleksandr Dakhno on 28/08/14.
//  Copyright (c) 2014 DAV. All rights reserved.
//

#import "DataManager.h"
#import "HTTPRequestManager.h"
#import "Scenario.h"
#import "CaseData.h"

@interface DataManager()
@end

@implementation DataManager

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static DataManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)requestScenariousListWithCompletion:(void(^)(NSArray *scenariousList, NSError *error))completion {

    NSString *urlString = @"http://expert-system.internal.shinyshark.com/scenarios/";
    NSURL *url = [NSURL URLWithString:urlString];

    HTTPRequestManager *requestManager = [HTTPRequestManager new];
    [requestManager makeRequestForURL:url completion:^(id receivedData, NSError *error) {

        if (error) {
            if (completion) completion(nil, error);
        } else {
            NSError *jsonParsingError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];

            if (jsonParsingError) {
                if (completion) completion(nil, jsonParsingError);
            } else {
                if ([object isKindOfClass:[NSDictionary class]]) {

                    id scenarios = object[@"scenarios"];
                    if ([scenarios isKindOfClass:[NSArray class]]) {
                        NSArray *rawScenariosList = scenarios;
                        NSMutableArray *scenariosList = [NSMutableArray array];
                        for (NSDictionary *rawScenario in rawScenariosList) {
                            Scenario *scenario = [Scenario new];
                            scenario.caseId = rawScenario[@"caseId"];
                            scenario.identifier = rawScenario[@"id"];
                            scenario.text = rawScenario[@"text"];

                            [scenariosList addObject:scenario];
                        }
                        if (completion) completion([scenariosList copy], nil);
                    }
                }
            }
        }
    }];
}

- (void)requestCaseWithId:(NSNumber *)identifier completion:(void(^)(CaseData *caseData, NSError *error))completion {

    NSString *urlString = [NSString stringWithFormat:@"http://expert-system.internal.shinyshark.com/cases/%d", identifier.intValue];
    NSURL *url = [NSURL URLWithString:urlString];

    HTTPRequestManager *requestManager = [HTTPRequestManager new];
    [requestManager makeRequestForURL:url completion:^(id receivedData, NSError *error) {

        if (error) {
            if (completion) completion(nil, error);
        } else {
            NSError *jsonParsingError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];

            if (jsonParsingError) {
                if (completion) completion(nil, jsonParsingError);
            } else {
                if ([object isKindOfClass:[NSDictionary class]]) {

                    NSDictionary *rawCaseData = object[@"case"];
                    if ([rawCaseData isKindOfClass:[NSDictionary class]]) {

                        CaseData *caseData = [CaseData new];
                        caseData.identifier = rawCaseData[@"id"] ?: nil;
                        id imageURL = rawCaseData[@"image"];
                        if ([imageURL isKindOfClass:[NSString class]]) {
                            caseData.imageURL =  imageURL;
                        }
                        caseData.text = rawCaseData[@"text"] ?: @"";
                        NSArray *rawAnswers = rawCaseData[@"answers"];
                        NSMutableArray *answers = [NSMutableArray array];
                        for (NSDictionary *rawScenario in rawAnswers) {
                            Scenario *scenario = [Scenario new];
                            scenario.caseId = rawScenario[@"caseId"];
                            scenario.identifier = rawScenario[@"id"];
                            scenario.text = rawScenario[@"text"];

                            [answers addObject:scenario];
                        }
                        caseData.answers = answers;
                        if (completion) completion(caseData, nil);
                    }
                }
            }
        }
    }];
}

- (void)loadImageForURL:(NSString *)urlString withCompletion:(void(^)(UIImage *image, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:urlString];

    if (url) {
        HTTPRequestManager *requestManager = [HTTPRequestManager new];
        [requestManager makeRequestForURL:url completion:^(id receivedData, NSError *error) {

            if (error) {
                if (completion) completion(nil, error);
            } else {
                UIImage *image = [[UIImage alloc] initWithData:receivedData];
                if (completion) completion(image, nil);
            }
        }];
    }
}


@end


