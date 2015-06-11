//
//  SQDownloadOperation.m
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import "SQDownloadOperation.h"

@interface SQDownloadOperation () <NSURLConnectionDataDelegate>

//请求路径
@property (strong, nonatomic) NSURL *url;

//保存路径
@property (copy, nonatomic) NSString *targetUrl;

//进度
@property (copy, nonatomic) void (^progressBlock)(float);

//完成
@property (copy, nonatomic) void (^finishedBlock)(NSString *, NSString *);

//输出流
@property (strong, nonatomic) NSOutputStream *fileStream;

//文件总大小
@property (assign, nonatomic) long long expectedContentSize;

//当前接收到的大小
@property (assign, nonatomic) long long fileSize;

@end

@implementation SQDownloadOperation

+ (instancetype)downloadOperation:(NSURL *)url progressed:(void(^)(float progress))progressBlock finished:(void(^)(NSString *, NSString *))finishedBlock {
    
    NSAssert(progressBlock != nil && finishedBlock != nil, @"进度和完成回调不能为空！");
    
    SQDownloadOperation *downloader = [[self alloc] init];
    downloader.url = url;
    downloader.progressBlock = progressBlock;
    downloader.finishedBlock = finishedBlock;
    
    return downloader;
}

- (void)main {
    @autoreleasepool {
        [self download];
    }
}

- (void)download {
    
    //发送请求获取文件大小和路径
    [self checkServerFileInfo];
    
    //获取本地下载文件大小
    self.fileSize = [self checkLocalFileInfo];
    
    if (self.expectedContentSize == self.fileSize) {
        self.progressBlock(1);
        self.finishedBlock(self.targetUrl, nil);
        return;
    }
    
    //断点续传
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.fileSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [[NSRunLoop currentRunLoop] run];//异步操作，开启运行循环监听代理事件
    
}

- (void)checkServerFileInfo {
    
    //发送HEAD方法请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.HTTPMethod = @"HEAD";
    
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //获取文件大小和保存url
    self.expectedContentSize = response.expectedContentLength;
    self.targetUrl = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
}

- (long long)checkLocalFileInfo {
    
    long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:self.targetUrl]) {
       NSDictionary *dict = [fileManager attributesOfItemAtPath:self.targetUrl error:NULL];
       fileSize = dict.fileSize;
    }
    
    if (fileSize > self.expectedContentSize) {
        [fileManager removeItemAtPath:self.targetUrl error:NULL];
    }
    
    return fileSize;
}


#pragma mark 下载代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //1.打开流
    [self.fileStream open];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    //拼接数据
    [self.fileStream write:data.bytes maxLength:data.length];
    
    //计算进度
    self.fileSize += data.length;
    float progress = (float)self.fileSize / self.expectedContentSize;
    
    self.progressBlock(progress);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    [self.fileStream close];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedBlock(self.targetUrl, nil);
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.fileStream close];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedBlock(self.targetUrl, @"连接失败！");
    });
}

#pragma mark 懒加载方法
- (NSOutputStream *)fileStream {
    if (_fileStream == nil) {
        _fileStream = [[NSOutputStream alloc] initToFileAtPath:self.targetUrl append:YES];
    }
    return _fileStream;
}


@end
