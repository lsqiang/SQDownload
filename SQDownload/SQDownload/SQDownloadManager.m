//
//  SQDownloadManager.m
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import "SQDownloadManager.h"
#import "SQDownloadOperation.h"

@interface SQDownloadManager ()

@property (strong, nonatomic)  NSMutableDictionary *operationCache;

@property (strong, nonatomic)  NSOperationQueue *operationQueue;

@end

@implementation SQDownloadManager

#pragma mark 对象方法传参
- (void)download:(NSURL *)url progressed:(void(^)(float progress))progressBlock finished:(void(^)(NSString *targetUrl, NSString *error))finishedBlock {
    
    if (self.operationCache[url] != nil) {
        NSLog(@"正在拼命下载，稍安勿躁");
        return;
    }
    
    SQDownloadOperation *downloader = [SQDownloadOperation downloadOperation:url progressed:progressBlock finished:^(NSString *targetUrl, NSString *error) {
        [self.operationCache removeObjectForKey:url];
        finishedBlock(targetUrl, error);
    }];
    
    [self.operationCache setObject:downloader forKey:url];
    
    [self.operationQueue addOperation:downloader];
    
}


#pragma mark 单例产生类
+ (instancetype)shareDownloadManager {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

#pragma mark 懒加载

- (NSMutableDictionary *)operationCache {
    if (_operationCache == nil) {
        _operationCache = [NSMutableDictionary dictionary];
    }
    return _operationCache;
}

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 2;
    }
    return _operationQueue;
}

@end
