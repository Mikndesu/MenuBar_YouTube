//
//  Setting.cpp
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/23.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include "Setting.hpp"
#include <iostream>
#include <fstream>
#include <vector>
#include "picojson.h"

Setting::Setting(std::string filepath) {
    m_filepath = filepath;
    if(std::fstream fs(m_filepath, std::ios::in); fs.fail()) {
        std::cout << "Setting File was Created" << std::endl;
        makeSettingFile();
    } else {
        std::cout << "Setting File Exists" << std::endl;
        std::string contents;
        if(std::getline(fs, contents); contents.empty()) {
            makeSettingFile();
        }
    }
}

std::vector<std::string> Setting::getSetting() {
    std::vector<std::string> settings;
    std::string contents, err;
    std::ifstream ifs(m_filepath, std::ios::in);
    std::getline(ifs, contents);
    picojson::value v;
    picojson::parse(v, contents.c_str(), contents.c_str()+strlen(contents.c_str()), &err);
    auto jsonObj = v.get<picojson::object>();
    for(auto it = jsonObj.begin(); it != jsonObj.end(); it++) {
        settings.push_back(it->second.to_str());
    }
    return settings;
}

void Setting::makeSettingFile() {
    std::ofstream ofs(m_filepath, std::ios::out);
    picojson::object obj;
    obj.emplace(std::make_pair("max_display_video", picojson::value("3")));
    obj.emplace(std::make_pair("video_width", picojson::value("460")));
    obj.emplace(std::make_pair("video_height", picojson::value("180")));
    ofs << picojson::value(obj) << std::endl;
    ofs.close();
    std::cout << "Setting File was Created at " << m_filepath << std::endl;
}
