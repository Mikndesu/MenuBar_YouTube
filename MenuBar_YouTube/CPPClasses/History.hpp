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

class History {
public:
    History(std::string);
    void addHistory(std::string, std::string);
    std::vector<std::string> getHistory();
    void editHistory();
private:
    std::string m_filepath;
    void makeHistoryFile();
    void checkHistory();
};

#endif /* History_hpp */
