//
//  ViewController.m
//  611-NSConnection断点续传
//
//  Created by Fly on 15/6/11.
//  Copyright (c) 2015年 sq. All rights reserved.
//

#import "ViewController.h"
#import "SQDownloadManager.h"
#import "ProgressButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ProgressButton *progressBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSString *urlStr = @"http://127.0.0.1/[阳光电影www.ygdy8.com].机械姬.BD.720p.中英双字幕.rmvb";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[SQDownloadManager shareDownloadManager] download:url progressed:^(float progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBtn.progress = progress;
        });
        
    } finished:^(NSString *targetUrl, NSString *error) {
        NSLog(@"已下载到%@", targetUrl);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
