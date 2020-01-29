//
//  History.hpp
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/21.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef History_hpp
#define History_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "picojson.h"

class History {
public:
    History(std::string);
    std::vector<std::string> getHistory();
    std::string searchKey(std::string);
    void addHistory(std::string, std::string);
    void editHistory();
    void clearHistory();
private:
    std::string m_filepath;
    picojson::object m_jsonObj;
    void makeHistoryFile();
    void checkHistory();
    void loadHistory();
};

#endif /* History_hpp */
