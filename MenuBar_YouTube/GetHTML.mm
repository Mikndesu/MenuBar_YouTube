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

#define write HTMLSource.push_back

void writeHTMLdownDisplay(std::string filepath, std::vector<std::string> vector) {
    int count = 0;
    std::vector<std::string> HTMLSource;
    std::vector<std::string> setting;
    NSBundle *bundle = [NSBundle mainBundle];
    std::ifstream ifs([[bundle pathForResource:@"asset/settings" ofType:@"json"] UTF8String], std::ios::in);
    std::string jsonobj, err;
    std::getline(ifs, jsonobj);
    picojson::value v;
    picojson::parse(v, jsonobj.c_str(), jsonobj.c_str()+strlen(jsonobj.c_str()), &err);
    auto json = v.get<picojson::object>();
    for(auto it = json.begin(); it != json.end(); it++) {
        setting.push_back(it->second.to_str());
    }
    write("<!DOCTYPE HTML>");
    write("<html>");
    write("<body>");
    std::string s = setting[0];
    int setting_count = std::stoi(s);
    for(auto iterator = vector.begin(); iterator != vector.end(); iterator++) {
        if(count == setting_count) {
        write("<iframe width="+setting[2]+" height="+setting[1]+" src=\"https://www.youtube.com/embed/"+*iterator+"\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>");
        count++;
        }
    }
    write("</body>");
    write("</html>");
    std::ofstream ofs(filepath, std::ios::out);
    for(auto it = HTMLSource.begin(); it != HTMLSource.end(); it++) {
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
    std::vector<std::string> v = videoIDs(doCurl(requestURL_first));
    writeHTMLdownDisplay([htmlPath UTF8String], v);
}

-(void) readFromHistory {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *settingsFile = [bundle pathForResource:@"asset/history" ofType:@"json"];
    std::ifstream ifs;
    ifs.open([settingsFile UTF8String], std::ios::in);
    std::string contents;
    std::getline(ifs, contents);
    if(contents.empty()) {
    } else {
    }
}

-(void) makeSettingFile {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *settingsFile = [bundle pathForResource:@"asset/settings" ofType:@"json"];
    std::ofstream ofs;
    ofs.open([settingsFile UTF8String], std::ios::trunc);
    picojson::object obj;
    obj.emplace(std::make_pair("max_display_video", picojson::value("4")));
    obj.emplace(std::make_pair("video_width", picojson::value("460")));
    obj.emplace(std::make_pair("video_height", picojson::value("180")));
    ofs << picojson::value(obj) << std::endl;
}

std::vector<std::string> videoIDs(std::string jsonObject) {
    picojson::value v;
    std::string err, check;
    std::vector<std::string> returnValue;
    picojson::parse(v, jsonObject.c_str(), jsonObject.c_str()+strlen(jsonObject.c_str()), &err);
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
