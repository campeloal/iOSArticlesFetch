//
//  ViewController.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXViewController.h"
#import "ALXHTTPRequest.h"

@interface ALXViewController ()


@end

@implementation ALXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ALXHTTPRequest *request = [[ALXHTTPRequest alloc] init];
    
    [request fetchArticles];
    
    [request fetchImageWithURLString:@"http://lorempixel.com/400/400/technics/1/"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
