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
#include <algorithm>
#include <string>
#include <vector>
#include "curl/curl.h"
#include "picojson.h"
#include "string"
#include "Setting.hpp"
#include "History.hpp"

@implementation GetHTML : NSObject

#define write HTMLSource.push_back

NSBundle *bundle = [NSBundle mainBundle];
NSString *settingpath = [bundle pathForResource:@"asset/settings" ofType:@"json"];
NSString *historyPath = [bundle pathForResource:@"asset/history" ofType:@"json"];
Setting setting([settingpath UTF8String]);
History history([historyPath UTF8String]);

void writeHTMLdownDisplay(std::string filepath, std::vector<std::string>& vector) {
    int count = 1;
    std::vector<std::string> HTMLSource;
    std::vector<std::string> settings = setting.getSetting();
    write("<!DOCTYPE HTML>");
    write("<html>");
    write("<body>");
    std::string s = settings[0];
    int setting_count = std::stoi(s);
    if(std::stoi(s) > 4) {
        setting_count = 4;
    } else {
        setting_count = std::stoi(s);
    }
    for(auto iterator = vector.begin(); iterator != vector.end(); iterator++) {
        std::cout << setting_count << std::endl;
        if(count <= setting_count) {
            write("<iframe width="+settings[2]+"height="+settings[1]+" src=\"https://www.youtube.com/embed/"+*iterator+"\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>");
            std::cout << count << std::endl;
            count++;
        } else {
            break;
        }
    }
    write("</body>");
    write("</html>");
    std::ofstream ofs(filepath, std::ios::out);
    for(auto it = HTMLSource.begin(); it != HTMLSource.end(); it++) {
        std::cout << *it << std::endl;
        ofs << *it << std::endl;
    }
    ofs.close();
}

-(void) searchYouTube: (NSString *) searchWord {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *htmlPath = [bundle pathForResource:@"asset/display" ofType:@"html"];
    NSString *apiPath = [bundle pathForResource:@"asset/APIKey" ofType:@"txt"];
    std::string apiKey;
    std::ifstream ifs([apiPath UTF8String], std::ios::in);
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
    std::string requestURL_first ="https://www.googleapis.com/youtube/v3/search?part=snippet&q="+search+"&key="+apiKey;
    std::vector<std::string> v = find_videoIDs(doCurl(requestURL_first));
    writeHTMLdownDisplay([htmlPath UTF8String], v);
}

-(void) make_edit_SettingFile {
}

-(void) showSelectedHistory:(NSString *) key {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *htmlPath = [bundle pathForResource:@"asset/display" ofType:@"html"];
    std::vector<std::string> v;
    v.push_back(history.searchKey([key UTF8String]));
    writeHTMLdownDisplay([htmlPath UTF8String], v);
}

-(NSMutableArray *) getHistory {
    std::vector<std::string> v = history.getHistory();
    NSMutableArray* mutableArray = [NSMutableArray array];;
    for(auto it = v.begin(); it != v.end(); it++) {
        [mutableArray addObject:[NSString stringWithUTF8String:(*it).c_str()]];
        std::cout << *it << std::endl;
    }
    NSLog(@"array : %@\n", mutableArray);
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
                    std::cout << iter->second.to_str() << std::endl;
                    v.push_back(iter->second.to_str());
                    std::cout << "Finish" << std::endl;
                }
            }
            if(auto ite = object.find("id"); ite != object.end()) {
                if(auto iter = ite->second.get<picojson::object>().find("videoId"); iter != ite->second.get<picojson::object>().end()) {
                    std::cout << iter->second.to_str() << std::endl;
                    returnValue.push_back(iter->second.to_str());
                    v.push_back(iter->second.to_str());
                    std::cout << "Finish" << std::endl;
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
    
    if(curl ==  nullptr) {
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
