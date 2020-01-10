//
//  GetHTML.m
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/08.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetHTML.h"
#include <iostream>
#include <fstream>
#include "curl/curl.h"
#include "string"

@implementation GetHTML : NSObject

-(void) writeHTMLdownDisplay: (NSString* ) filepath {
    std::ofstream ofs;
    ofs.open([filepath UTF8String], std::ios::trunc);
    ofs << doCurl([filepath UTF8String]) << std::endl;
    ofs.close();
}

std::string doCurl(std::string filepath) {
    CURL* curl;
    CURLcode ret;
    
    curl = curl_easy_init();
    std::string reqURL = "https://www.google.com";
    std::string userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";
    std::string chunk;
    
    if(curl == NULL) {
        std::cerr << "curl_easy_init() failed" << std::endl;
    }
    
    curl_easy_setopt(curl, CURLOPT_URL, reqURL.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callbackWrite);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, userAgent.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    
    if (ret != CURLE_OK) {
        std::cerr << "curl_easy_perform() failed." << std::endl;
    }
    
    return chunk;
}

size_t callbackWrite(char *ptr, size_t size, size_t nmemb, std::string *stream) {
    int datalength = static_cast<int>(size * nmemb);
    stream -> append(ptr, datalength);
    return datalength;
}


@end
