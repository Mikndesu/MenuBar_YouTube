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
#include <string>
#include <vector>
#include "curl/curl.h"
#include "picojson.h"
#include "string"
#include "Setting.hpp"
#include "History.hpp"

@implementation GetHTML : NSObject

#define WRITE HTMLSource.push_back
#define Release

std::string homeDir = [NSHomeDirectory() UTF8String];
Setting setting(homeDir+"/settings.json");
History history(homeDir+"/history.json");

void writeHTMLdownDisplay(std::string filepath, const std::vector<std::string>& vector) {
    int count = 1;
    std::vector<std::string> HTMLSource;
    std::vector<std::string> settings = setting.getSetting();
    WRITE("<!DOCTYPE HTML>");
    WRITE("<html>");
    WRITE("<body>");
    std::string s = settings[0];
    int setting_count = std::stoi(s);
    if(std::stoi(s) > 4) {
        setting_count = 4;
    } else {
        setting_count = std::stoi(s);
    }
    for(auto iterator = vector.begin(); iterator != vector.end(); iterator++) {
        if(count <= setting_count) {
            WRITE("<iframe width="+settings[2]+"height="+settings[1]+" src=\"https://www.youtube.com/embed/"+*iterator+"\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>");
            count++;
        } else {
            break;
        }
    }
    WRITE("</body>");
    WRITE("</html>");
    std::ofstream ofs(filepath, std::ios::out);
    for(auto it = HTMLSource.begin(); it != HTMLSource.end(); it++) {
        ofs << *it << std::endl;
    }
    ofs.close();
}

-(void) clearHistory {
    history.clearHistory();
}

-(void) searchYouTube: (NSString *) searchWord {
    std::string apiKey;
#ifdef Debug
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *apiPath = [bundle pathForResource:@"asset/APIKey" ofType:@"txt"];
    std::ifstream ifs([apiPath UTF8String], std::ios::in);
    std::getline(ifs, apiKey);
    ifs.close();
#endif
#ifdef Release
    apiKey = "";
#endif
    std::string search = [searchWord UTF8String];
    std::string from = " ";
    std::string to = "+";
    std::string::size_type pos = search.find(from);
    while(pos != std::string::npos) {
        search.replace(pos, from.size(), to);
        pos = search.find(from, pos + to.size());
    }
    std::string requestURL_first="https://www.googleapis.com/youtube/v3/search?part=snippet&q="+search+"&key="+apiKey;
    std::vector<std::string> v = find_videoIDs(doCurl(requestURL_first));
    writeHTMLdownDisplay(homeDir+"/display.html", v);
}

-(void) editSetting: (NSString *) first second: (NSString *) second third:(NSString *) third {
    setting.editSetting([first UTF8String], [second UTF8String], [third UTF8String]);
}


-(void) showSelectedHistory:(NSString *) key {
    std::vector<std::string> v;
    v.push_back(history.searchKey([key UTF8String]));
    writeHTMLdownDisplay(homeDir+"/display.html", v);
}

-(NSMutableArray *) getHistory {
    std::vector<std::string> v = history.getHistory();
    NSMutableArray* mutableArray = [NSMutableArray array];;
    for(auto it = v.begin(); it != v.end(); it++) {
        [mutableArray addObject:[NSString stringWithUTF8String:(*it).c_str()]];
        std::cout << *it << std::endl;
    }
    return mutableArray;
}

std::vector<std::string> find_videoIDs(std::string jsonObject) {
    int count = 1;
    std::vector<std::string> settings = setting.getSetting();
    picojson::value v;
    std::string err, check;
    std::vector<std::string> returnValue;
    picojson::parse(v, jsonObject.c_str(), jsonObject.c_str()+strlen(jsonObject.c_str()), &err);
    auto array = v.get<picojson::object>()["items"].get<picojson::array>();
    std::string s = settings[0];
    int setting_count = std::stoi(s);
    if(std::stoi(s) > 4) {
        setting_count = 4;
    } else {
        setting_count = std::stoi(s);
    }
    for(auto it = array.begin(); it != array.end(); it++) {
        if(count <= setting_count) {
            std::vector<std::string> v;
            auto object = it->get<picojson::object>();
            if(auto ite = object.find("snippet"); ite != object.end()) {
                if(auto iter = ite->second.get<picojson::object>().find("title"); iter != ite->second.get<picojson::object>().end()) {
                    v.push_back(iter->second.to_str());
                }
            }
            if(auto ite = object.find("id"); ite != object.end()) {
                if(auto iter = ite->second.get<picojson::object>().find("videoId"); iter != ite->second.get<picojson::object>().end()) {
                    returnValue.push_back(iter->second.to_str());
                    v.push_back(iter->second.to_str());
                }
            }
            if(v[1] != "") {
                history.addHistory(v[0], v[1]);
            }
            count++;
        } else {
            break;
        }
    }
    return returnValue;
}

std::string doCurl(std::string word) {
    CURL* curl;
    CURLcode ret;
    
    curl = curl_easy_init();
    std::string chunk;
    
    curl_easy_setopt(curl, CURLOPT_URL, word.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callbackWrite);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    
    return chunk;
}

size_t callbackWrite(char *ptr, size_t size, size_t nmemb, std::string *stream) {
    int datalength = static_cast<int>(size * nmemb);
    stream -> append(ptr, datalength);
    return datalength;
}

@end
