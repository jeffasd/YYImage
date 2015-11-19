//
//  YYImageExample.m
//  YYKitExample
//
//  Created by ibireme on 15/7/18.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYImageExample.h"
#import "YYImage.h"
#import "UIView+YYAdd.h"
#import <ImageIO/ImageIO.h>
#import <WebP/demux.h>
#import "YYImageCoder.h"

@interface YYImageExample()
{
    NSMutableArray *_imageArray;
    NSMutableArray *_delayArray;
}
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation YYImageExample

- (void)viewDidLoad {
    self.title = @"YYImage Demo";
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"Animated Image" class:@"YYImageDisplayExample"];
    [self addCell:@"Progressive Image" class:@"YYImageProgressiveExample"];
    //[self addCell:@"Web Image" class:@"YYWebImageExample"];
    //[self addCell:@"Benchmark" class:@"YYImageBenchmark"];
    [self.tableView reloadData];
    
    //快速测试 处理图片到gif的能力
    
    // 缓存图片路径
#define FD_IMAGE_PATH(file) [NSString stringWithFormat:@"%@/Documents/image/%@",NSHomeDirectory(),file]
    _imageArray = [[NSMutableArray alloc] init];//gif的原始图片
    _delayArray = [[NSMutableArray alloc] init];//gif的播放时间间隔
    for (int n = 0; n <= 388; n ++)
    {
        //注意:本程序的逻辑是先把图片保存到本地的临时文件夹,再从临时文件夹里取出,进行合成gif
        //定义图片文件名
        NSString *gifSaveString = [NSString stringWithFormat:@"joy%d.png",n];
        
        UIImage *image = [UIImage imageWithContentsOfFile:FD_IMAGE_PATH(gifSaveString)];//从指定索引插入元素
        [_imageArray insertObject:image
                          atIndex:n];//是插入到指定的索引的前
        
        
        NSNumber *number = [NSNumber numberWithFloat:1.5f];//数字转换成浮点数(必须转换成浮点数才能加到数组里)
        [_delayArray insertObject:number atIndex:n];
    }
    NSLog(@"the image is %@", _imageArray);
    // 编码动态图 (支持 GIF/APNG/WebP):
    YYImageEncoder *gifEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
    gifEncoder.loopCount = 0;
    for (int i = 0; i <= 388; ++i) {
        [gifEncoder addImage:_imageArray[i] duration:0.03f];
    }
    NSData *gifData = [gifEncoder encode];
    NSString *gifSaveString = [NSString stringWithFormat:@"atest_01.gif"];
    NSString *path = FD_IMAGE_PATH(gifSaveString);
    [gifData writeToFile:FD_IMAGE_PATH(gifSaveString) atomically:YES];
    
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
