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

/**
 *  Method that does a get request
 */
-(void) getRequest;

@optional
/**
 *  Optional method to threat the case when
 *the url is null
 *
 *  @param url url to be analyzed
 *
 *  @return yes if the url exists, otherwise, no
 */
-(BOOL) urlExists:(NSString*)url;

@end

@interface ALXHTTPRequest : NSObject

@end
