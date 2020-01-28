//
//  GetHTML.h
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/08.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef GetHTML_h
#define GetHTML_h
#import <Foundation/Foundation.h>

@interface GetHTML : NSObject

-(void) searchYouTube: (NSString *) searchWord;
-(NSMutableArray *) getHistory;
-(void) showSelectedHistory :(NSString *) key;
-(void) editSetting: (NSString *) first second: (NSString *) second third:(NSString *) third;

@end

#endif /* GetHTML_h */
