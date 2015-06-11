//
//  SQDownloadOperation.h
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQDownloadOperation : NSOperation

//实例化方法，设置类属性
+ (instancetype)downloadOperation:(NSURL *)url progressed:(void(^)(float progress))progressBlock finished:(void(^)(NSString *targetUrl, NSString *error))finishedBlock;

@end
