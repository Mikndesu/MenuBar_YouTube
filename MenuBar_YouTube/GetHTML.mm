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
#include <vector>
#include "curl/curl.h"
#include "picojson.h"
#include "string"

@implementation GetHTML : NSObject

void writeHTMLdownDisplay(std::string filepath, std::vector<std::string> v) {
    std::vector<std::string> writeHTML;
    writeHTML.push_back("<!DOCTYPE HTML>");
    writeHTML.push_back("<html>");
    writeHTML.push_back("<body>");
    for(auto iterator = v.begin(); iterator != v.end(); iterator++) {
        writeHTML.push_back("<iframe width=\"459\" height=\"225\" src=\"https://www.youtube.com/embed/"+*iterator+"\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>");
    }
    writeHTML.push_back("</body>");
    writeHTML.push_back("</html>");
    std::ofstream ofs;
    ofs.open(filepath, std::ios::out);
    for(auto it = writeHTML.begin(); it != writeHTML.end(); it++) {
        ofs << *it << std::endl;
    }
    ofs.close();
}

-(void) searchYouTube: (NSString *) searchWord {
    NSBundle* bundle = [NSBundle mainBundle];
    NSString *htmlPath = [bundle pathForResource:@"display" ofType:@"html"];
    NSString *apiPath = [bundle pathForResource:@"APIKey" ofType:@"txt"];
    
    std::string apiKey;
    std::ifstream ifs;
    ifs.open([apiPath UTF8String], std::ios::in);
    std::getline(ifs, apiKey);
    ifs.close();
    std::string search = [searchWord UTF8String];
    std::string from = " ";
    std::string to = "+";
    std::string::size_type pos = search.find(from);
    while(pos != std::string::npos) {
        search.replace(pos, from.size(), to);
        pos = search.find(from, pos + to.size());
    }
    std::string requestURL ="https://www.googleapis.com/youtube/v3/search?part=snippet&q="+search+"&key="+apiKey;
    std::vector<std::string> v = writeData(doCurl(requestURL));
    writeHTMLdownDisplay([htmlPath UTF8String], v);
}

std::vector<std::string> writeData(std::string jsonObject) {
    picojson::value v;
    std::string err, check;
    std::vector<std::string> returnValue;
    picojson::parse(v, jsonObject.c_str(), jsonObject.c_str()+strlen(jsonObject.c_str()), &err);
    std::cout << jsonObject << std::endl;
    picojson::object object = v.get<picojson::object>();
    picojson::array array = object["items"].get<picojson::array>();
    for(auto it = array.begin(); it != array.end(); it++) {
        picojson::object& obj = it->get<picojson::object>();
        for(auto ite = obj.begin(); ite != obj.end(); ite++) {
            if(ite->first == "id") {
                picojson::object obje = ite->second.get<picojson::object>();
                for(auto i = obje.begin(); i != obje.end(); i++) {
                    if(i->first == "videoId") {
                        std::cout << i->second.to_str() << std::endl;
                        returnValue.push_back(i->second.to_str());
                    }
                }
            }
        }
    }
    return returnValue;
}

std::string doCurl(std::string word) {
    CURL* curl;
    CURLcode ret;

    curl = curl_easy_init();
    std::string chunk;
    std::string userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";

    if(curl == NULL) {
        std::cerr << "curl_easy_init() failed" << std::endl;
    }
    
    curl_easy_setopt(curl, CURLOPT_URL, word.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callbackWrite);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    std::cout << curl_easy_strerror(ret) << std::endl;

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
