//
//  History.cpp
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/21.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include "History.hpp"
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "picojson.h"

History::History() {
}

History::History(std::string filepath) {
    m_filepath = filepath;
    if(std::fstream fs(m_filepath, std::ios::in); fs.fail()) {
        makeHistoryFile();
    } else {
        std::cout << "History File Exists" << std::endl;
        std::string contents;
        if(std::getline(fs, contents); contents.empty()) {
            makeHistoryFile();
        }
    }
}

std::vector<std::string> History::getHistory() {
    std::vector<std::string> histories;
    std::string contents, err;
    std::ifstream ifs(m_filepath, std::ios::in);
    std::getline(ifs, contents);
    ifs.close();
    picojson::value v;
    picojson::parse(v, contents.c_str(), contents.c_str()+strlen(contents.c_str()), &err);
    auto jsonObj = v.get<picojson::object>();
    for(auto it = jsonObj.begin(); it != jsonObj.end(); it++) {
        histories.push_back(it->second.to_str());
    }
    return histories;
}

void History::addHistory(std::string videoName, std::string videoId) {
    std::string contents, err;
    picojson::value val;
    std::ifstream ifs(m_filepath, std::ios::in);
    std::getline(ifs, contents);
    ifs.close();
    std::cout << contents << std::endl;
    picojson::parse(val, contents.c_str(), contents.c_str() + strlen(contents.c_str()), &err);
    std::cout << "here" << err << std::endl;
    if(err.empty()) {
        auto jsonObj = val.get<picojson::object>();
        if(bool isExist = jsonObj.count(videoName); !isExist) {
            jsonObj.emplace(std::make_pair(videoName, picojson::value(videoId)));
        }
        std::ofstream ofs(m_filepath, std::ios::out);
        ofs << picojson::value(jsonObj) << std::endl;
        std::cout << picojson::value(jsonObj) << std::endl;
        ofs.close();
    } else {
        std::exit(1);
    }
}

void History::makeHistoryFile() {
    std::ofstream ofs(m_filepath, std::ios::out);
    ofs << "{}" << std::endl;
    ofs.close();
    std::cout << "History File was Created at " << m_filepath << std::endl;
}


