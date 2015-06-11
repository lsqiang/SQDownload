# SQDownload
 用NSURLConection封装的下载，支持断点续传

####一、将此包导入项目
![enter image description here](https://github.com/lsqiang/SQDownload/blob/master/1.png?raw=true)

###二、import "SQDownloadManager.h"

        
        /* 
        * url:(NSURL服务器文件请求地址)
        * progressed:(进程回调block)
        * finished:(下载完成操作)
        */
        [[SQDownloadManager shareDownloadManager] download:url progressed:^(float progress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBtn.progress = progress;
            });
            
        } finished:^(NSString *targetUrl, NSString *error) {
            NSLog(@"已下载到%@", targetUrl);
        }];
