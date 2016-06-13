//
//  CZVideoParser.m
//  AFN简单演练
//
//  Created by 张玺科 on 16/6/12.
//  Copyright © 2016年 张玺科. All rights reserved.
//

#import "CZVideoParser.h"
#import "Video.h"

@interface CZVideoParser()<NSXMLParserDelegate>

@property (nonatomic, copy) void (^completionBlock)(NSArray *);

@end

@implementation CZVideoParser {
    /**
     * 视频模型列表
     */
    NSMutableArray <Video *> *_videoList;
    
    /**
     * 第3步拼接的内容字符串
     */
    NSMutableString *_content;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 0. 初始化模型数组
        _videoList = [NSMutableArray array];
        _content = [NSMutableString string];
    }
    return self;
}

- (NSArray *)parseWithParser:(NSXMLParser *)parser{
    parser.delegate = self;
    
    [parser parse];
    
    return _videoList.copy;
}

- (void)parseWithData:(NSData *)data completion:(void (^)(NSArray<Video *> *))completion{
    NSAssert(completion != 0, @"必须传入回调 block");
    
    self.completionBlock = completion;
    
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    
    parser.delegate = self;
    
    [parser parse];
    
    NSLog(@"come here %@",_videoList);
}

- (NSArray *)parseWithData:(NSData *)data {
    // 1. 创建解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    // 2. 设置代理
    parser.delegate = self;
    
    // 3. 解析器开始解析 - parse 是同步的！
    // 方法执行完成，解析已经完成
    // 可以不需要 block 回调！
    [parser parse];
    
    // 4. 返回结果
    return _videoList.copy;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"1. 开始解析文档 %@", [NSThread currentThread]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    NSLog(@"2. 开始元素 %@ %@", elementName, attributeDict);
    
    if ([elementName isEqualToString:@"video"]) {
        Video *model = [Video new];
        
        for (NSString *key in attributeDict) {
            id value = attributeDict[key];
            
            [model setValue:value forKey:key];
        }
        [_videoList addObject:model];
    }
    [_content setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"===> %@", string);
    // 拼接字符串
    [_content appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    NSLog(@"4. 结束节点 %@", elementName);
    // 1. 判断节点名称
    if ([elementName isEqualToString:@"video"] || [elementName isEqualToString:@"videos"]) {
        return;
    }
    
    // 2. 处理其它的属性内容
    // 1> 获得第 2 步建立的 video 模型
    Video *model = _videoList.lastObject;
    
    // 2> 利用 KVC 设置属性 - KVC 不会影响对象的引用关系！
    if ([elementName isEqualToString:@"name"]) {
        // model.name = _content.copy;
        model.name = _content;
        
        return;
    }
    [model setValue:_content forKey:elementName];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{

    if (self.completionBlock != nil) {
        self.completionBlock(_videoList.copy);
    }
}
@end
