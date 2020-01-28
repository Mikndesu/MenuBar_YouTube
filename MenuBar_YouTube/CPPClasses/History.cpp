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

History::History(std::string filepath) {
    m_filepath = filepath;
    if(std::fstream fs(m_filepath, std::ios::in); fs.fail()) {
        std::cout << "History File was Created" << std::endl;
        makeHistoryFile();
    } else {
        std::cout << "History File Exists" << std::endl;
        std::string contents;
        if(std::getline(fs, contents); contents.empty()) {
            makeHistoryFile();
        } else {
            checkHistory();
        }
    }
    loadHistory();
}

std::vector<std::string> History::getHistory() {
    std::vector<std::string> histories;
    auto jsonObj = m_jsonObj;
    std::for_each(jsonObj.begin(), jsonObj.end(), [&histories](auto value){histories.push_back(value.first);});
    return histories;
}

void History::addHistory(std::string videoName, std::string videoId) {
    auto jsonObj = m_jsonObj;
    if(bool isExist = jsonObj.count(videoName); !isExist) {
        jsonObj.emplace(std::make_pair(videoName, picojson::value(videoId)));
    }
    std::ofstream ofs(m_filepath, std::ios::out);
    ofs << picojson::value(jsonObj) << std::endl;
    std::cout << picojson::value(jsonObj) << std::endl;
    ofs.close();
    m_jsonObj = jsonObj;
}

std::string History::searchKey(std::string key) {
    auto jsonObj = m_jsonObj;
    if(jsonObj.count(key)) {
        return jsonObj.at(key).to_str();
    }
    return "";
}

void History::checkHistory() {
    
}

void History::makeHistoryFile() {
    std::ofstream ofs(m_filepath, std::ios::out);
    ofs << "{}" << std::endl;
    ofs.close();
    std::cout << "History File was Created at " << m_filepath << std::endl;
}

void History::loadHistory() {
    std::string contents, err;
    std::ifstream ifs(m_filepath, std::ios::in);
    std::getline(ifs, contents);
    picojson::value v;
    picojson::parse(v, contents.c_str(), contents.c_str()+strlen(contents.c_str()), &err);
    if(err.empty()) {
    m_jsonObj = v.get<picojson::object>();
    } else {
        std::cout << err << std::endl;
        std::exit(1);
    }
}


