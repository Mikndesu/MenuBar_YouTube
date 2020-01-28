//
//  Setting.hpp
//  MenuBar_YouTube
//
//  Created by MitsukiGoto on 2020/01/23.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef Setting_hpp
#define Setting_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "picojson.h"

class Setting {
public:
    Setting(std::string);
    void editSetting(std::string, std::string, std::string);
    std::vector<std::string> getSetting();
private:
    std::string m_filepath;
    picojson::object m_jsonObj;
    void makeSettingFile(std::string, std::string, std::string);
    void loadSetting();
};

#endif /* Setting_hpp */
