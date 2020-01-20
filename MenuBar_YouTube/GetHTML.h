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
-(void) readFromHistory;
-(void) make_edit_SettingFile;

@end

#endif /* GetHTML_h */
