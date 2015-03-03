//
// Created by Aleksandr Dakhno on 28/08/14.
// Copyright (c) 2014 DAV. All rights reserved.
//

@interface HTTPRequestManager : NSObject

- (void)makeRequestForURL:(NSURL *)url completion:(void (^)(id receivedData, NSError *error))completion;
@end