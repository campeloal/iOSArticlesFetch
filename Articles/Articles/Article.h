//
//  Article.h
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/23/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * authors;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * isRead;

@end
