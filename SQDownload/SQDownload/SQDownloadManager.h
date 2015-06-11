//
//  SQDownloadManager.h
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQDownloadManager : NSObject

+ (instancetype)shareDownloadManager;

- (void)download:(NSURL *)url progressed:(void(^)(float progress))progressBlock finished:(void(^)(NSString *targetUrl, NSString *error))finishedBlock;

@end
