//
//  ALXHTTPRequest.h
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HTTPRequestProtocol <NSObject>

@required

-(void) fetchURL;

@optional
-(BOOL) urlExists:(NSString*)url;

@end

@interface ALXHTTPRequest : NSObject

@end
