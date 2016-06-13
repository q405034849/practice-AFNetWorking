//
//  ViewController.m
//  AFN简单演练
//
//  Created by 张玺科 on 16/6/12.
//  Copyright © 2016年 张玺科. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CZVideoParser.h"
#import "CZAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self postLogin];
//    [self getDemo3];
//    [self getDemo2];
//    [self getDemo];
//    [self jsonDemo];
//    [self xmlDemo];
//    [self downLoad];
//    [self postUpLoad];
    [self https12306];
}


- (void)xmlDemo{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [manager GET:@"http://localhost/videos02.xml" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        NSArray *list = [[CZVideoParser new] parseWithParser:responseObject];
        NSLog(@"%@", list);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)jsonDemo {
    
    // 1. 管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置响应的支持的数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    // 2. 发起网络请求
    [manager GET:@"http://www.weather.com.cn/adat/sk/101010100.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)downLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost/321.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@", downloadProgress);
        NSLog(@"%f --- %@", downloadProgress.fractionCompleted, downloadProgress.localizedDescription);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 目标文件名
        NSString *fileName = response.suggestedFilename;
        // 追加路径
        NSString *filePath = fileName.cz_appendCacheDir;
        
        // 将文件路径转换成 URL
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@", filePath);
    }] resume];
}

- (void)https12306 {
    
    // 1. 管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 允许无效的证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 不验证域名
    manager.securityPolicy.validatesDomainName = NO;
    
    // 设置响应的数据格式 － 二进制格式 - HTML
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2. GET - html
    [manager GET:@"https://kyfw.12306.cn/otn/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 将返回的二进制数据转换成 html 字符串
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", html);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)postUpLoad{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"status": @"happy"};
    
    NSURL *fileUrl1 = [[NSBundle mainBundle] URLForResource:@"001.jpg" withExtension:nil];
    NSURL *fileUrl2 = [[NSBundle mainBundle] URLForResource:@"002.jpg" withExtension:nil];
    
    NSArray *files = @[fileUrl1, fileUrl2];
    
    [manager POST:@"http://localhost/upload/upload-m.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileURL:fileUrl1 name:@"userfile[]" fileName:fileUrl1.lastPathComponent mimeType:@"application/octet-stream" error:NULL];
        for (NSURL *fileURL in files) {
            [formData appendPartWithFileURL:fileURL name:@"userfile[]" fileName:fileURL.lastPathComponent mimeType:@"application/octet-stream" error:NULL];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)postLogin {
    
    // 1. 管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2. 发起网络请求
    NSDictionary *params = @{@"username": @"张三", @"password": @"123"};
    
    [manager POST:@"http://localhost/php/login.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"POST %@ %@ %@", responseObject, [responseObject class], [NSThread currentThread]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)getDemo3 {
    
    // 1. 管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2. 发起网络请求
    NSDictionary *params = @{@"username": @"zhangsan", @"password": @"zhang"};
    
    [manager GET:@"http://localhost/php/login.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@ %@ %@", responseObject, [responseObject class], [NSThread currentThread]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)getDemo2 {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://localhost/php/login.php?username=zhang&password=123" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@ %@ %@",responseObject,[responseObject class],[NSThread currentThread]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)getDemo{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    [manger GET:@"http://localhost/demo.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@ %@ %@",responseObject,[responseObject class],[NSThread currentThread]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
