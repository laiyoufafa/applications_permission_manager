/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { backBar } from "../common/components/backBar";
import { alphabetIndexerComponent } from "../common/components/alphabeticalIndex";
import { textInput } from "../common/components/search";
import router from '@system.router';
import bundle from "@ohos.bundle";
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { groups, userGrantPermissions, permissionGroupPermissions, noNeedDisplayApp } from "../common/model/permissionGroup";
import { permissionGroups, permissionGroupIds } from "../common/model/permissionGroup";
import { makePy } from "../common/utils/utils";
import Constants from '../common/utils/constant';

var TAG = 'PermissionManager_MainAbility:'

@Extend(Image) function customizeImage(width: number, height: number) {
  .objectFit(ImageFit.Contain)
  .width(width)
  .height(height)
};

interface applicationPermissions {
  'bundleName': string,
  'api': number,
  'iconId': string,
  'permissions': string[],
  'labelId': string,
  'tokenId': number,
  'groupId': number[]
};

interface permissionApplications {
  'permission': string,
  'groupName': string,
  'bundleNames': string[],
  'icon': string
};

interface groupPermission {
  'group': string,
  'permissions': string[],
  'groupName': string,
  'icon': string,
  'isShow':boolean
};

let bundleInfosList: any[] = []; // Permission information array
let textInput_placeholder: any = ''
const FUZZY_LOCATION_PERMISSION = 'ohos.permission.APPROXIMATELY_LOCATION'
const API_VERSION_SUPPORT_STAGE = 9

@Entry
@Component
struct authorityManagementPage {
  @Builder ListItemLayout(item, index) {
    ListItem() {
      Row() {
        Column() {
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Row() {
              Image(item.icon)
                .customizeImage(Constants.MANAGEMENT_IMAGE_WIDTH, Constants.MANAGEMENT_IMAGE_HEIGHT)
                .margin({ right: Constants.MANAGEMENT_IMAGE_MARGIN_RIGHT })
              Text(item.groupName)
                .fontSize(Constants.TEXT_MIDDLE_FONT_SIZE)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.label_color'))
                .flexGrow(Constants.FLEX_GROW)
              Image($r('app.media.rightarrow'))
                .customizeImage(Constants.IMAGE_WIDTH, Constants.IMAGE_HEIGHT)
            }
            .width(Constants.FULL_WIDTH)
            .height(Constants.MANAGEMENT_ROW_HEIGHT)
          }
          if (!index) {
            Row() {
              Flex() {
                Column().width(Constants.MANAGEMENT_TEXT_DECORATION_MARGIN_LEFT)
                Column()
                  .backgroundColor($r('app.color.text_decoration_color'))
                  .height(Constants.TEXT_DECORATION_HEIGHT)
                  .flexGrow(Constants.FLEX_GROW)
              }
            }
          }
        }.onClick(() => {
          if (item.groupName === '其他权限' || item.groupName === '电话' || item.groupName === '通讯录' || item.groupName === '信息'
          || item.groupName === '通话记录' || item.groupName === '日历') {
            router.push({
              uri: 'pages/authority-secondary',
              params: { routerData: this.allPermissionApplications, backTitle: item.groupName }
            })
          } else {
            var dataList = this.allPermissionApplications.filter((ele) => {
              return ele.groupName === item.group
            })

            globalThis.currentPermissionGroup = item.group
            router.push({
              uri: 'pages/authority-tertiary-groups',
              params: { routerData: dataList, backTitle: item.groupName  }
            })
          }
        })
      }
    }.padding({ left: Constants.DEFAULT_PADDING_START, right: Constants.DEFAULT_PADDING_END })
  }

  @State allApplicationPermissions: applicationPermissions[] = []; // All permissions apply
  @State allPermissions: string[] = []; // All permissions
  @State allSystemPermissions: string[] = []; // All system permissions
  @State allUserPermissions: string[] = []; // All user rights
  @State allPermissionApplications: permissionApplications [] = [] // All app permissions
  @State allGroups: string[] = [] // All groups
  @State allGroupPermission: groupPermission[] = [] // All group permissions
  @State currentIndex: number = 0
  @Builder TabBuilder(index: number) {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(index ? $r('app.string.application') : $r('app.string.authority'))
        .fontColor(this.currentIndex == index ? $r('app.color.button_color') : $r('app.color.label_color'))
        .fontWeight(this.currentIndex == index ? FontWeight.Bold : FontWeight.Regular)
        .lineHeight(Constants.TEXT_LINE_HEIGHT)
      if(this.currentIndex == index) {
        Row().width(Constants.FULL_WIDTH).height(Constants.TAB_DECORATION_HEIGHT)
          .backgroundColor($r('app.color.button_color'))
          .position({ y: Constants.TAB_DECORATION_POSITION_Y })
      }
    }.height(Constants.TAB_HEIGHT)
  }

  /**
   * Convert the permission array into key, value key-value objects for easy sorting
   * @param {Array} order User rights
   * @return {Object} return the processed object
   */
  orderDict(order) {
    let result = {};
    for (let i = 0; i < order.length; i++) {
      let key = order[i];
      result[key] = i;
    }
    return result;
  }

  /**
   * Compare and sort the permission array according to the permission key value
   * @param {String} prop Sort by permission
   * @param {Object} orderSort objects to be sorted
   * @return {Array} Returns a sorted array of permissions
   */
  compare(prop, orderSort) {
    return function(a, b) {
      let aSortValue = orderSort[a[prop]];
      let bSortValue = orderSort[b[prop]];
      if (aSortValue == undefined) {
        throw new Error('当前的字段不在排序列表里：' + a[prop]);
      }
      if (bSortValue == undefined) {
        throw new Error('当前的字段不在排序列表里：' + b[prop]);
      }
      return aSortValue - bSortValue;
    }
  }

  /**
   * Get all app permission information
   * @param {Array} allPermissions All permissions
   * @param {Object} allApplicationPermissions All app permissions
   */
  getAllBundlePermissions(allPermissions: string[], allApplicationPermissions: applicationPermissions[]) {
    bundle.getAllBundleInfo(Constants.PARMETER_BUNDLE_FLAG).then(async(res) => {
      const bundleInfos = res;
      var count = bundleInfos.length;
      if (count <= 0) {
        console.info(TAG + 'bundle.getAllBundleInfo result.length less than or equal to zero');
        return;
      }
      var infoIndex = 0;
      for (let i = 0; i < count; i++) {
        var info = bundleInfos[i];
        // Filter blank icon icon and text label resources
        try {
          const ret = await bundle.queryAbilityByWant({
            bundleName: info.name,
            action: "action.system.home",
            entities: ["entity.system.home"]
          }, bundle.BundleFlag.GET_ABILITY_INFO_WITH_APPLICATION, Constants.USERID);
        } catch(e) {
          console.log(TAG + 'queryAbilityByWant catch error: ' + JSON.stringify(e))
          continue;
        }

        if (noNeedDisplayApp.indexOf(info.name) != -1) {
          continue;
        }
        await this.deduplicationPermissions(info, allPermissions, allApplicationPermissions);
        this.updateAppLabel(infoIndex, info.name, info.appInfo.label);
        this.updateAppIcon(infoIndex, info.name);
        infoIndex = infoIndex + 1;
      }
      this.getAllPermissionApplications();
      let orderSort = this.orderDict(userGrantPermissions);
      this.allPermissionApplications.sort(this.compare('permission', orderSort));
      this.getAllGroupPermission();
      bundleInfosList = this.allApplicationPermissions;
      bundleInfosList.forEach((item) => {
        if (!isNaN(item.labelId)) {
          item.alphabeticalIndex = '';
        } else {
          item.alphabeticalIndex = makePy(item.labelId)[0].slice(0, 1); // Get the first letter in the returned initials array
        }
      })
    })
      .catch((error) => {
        console.error(TAG + 'bundle.getAllBundleInfo failed. Cause: ' + JSON.stringify(error));
      })
  }

  /**
   * Get the corresponding permission group id according to the permission
   * @param {String} permission app name id
   * @return {Number} groupId
   */
  getPermissionGroupByPermission(permission: string) {
    for (let i = 0; i < permissionGroups.length; i++) {
      if (permissionGroups[i].permissionName == permission) {
        return groups[permissionGroups[i].groupId];
      }
    }
  }

  /**
   * Get all app permission information
   */
  getAllPermissionApplications() {
    const this_ = this;
    var leng = this_.allPermissions.length;
    if (leng > 0) {
      for (let i = 0; i < leng; i++) {
        if (userGrantPermissions.indexOf(this_.allPermissions[i]) == -1) {
          this_.allSystemPermissions.push(this_.allPermissions[i]);
        } else {
          this_.allUserPermissions.push(this_.allPermissions[i]);
        }
      }
    }
    for (let i = 0; i < this_.allUserPermissions.length; i++) {
      var permissionGroup = this_.getPermissionGroupByPermission(this_.allUserPermissions[i]);
      var icon: string = permissionGroup.icon;
      var bundleNames: string[] = [];
      for (let j = 0; j < this_.allApplicationPermissions.length; j++) {
        if (this_.allApplicationPermissions[j].permissions.indexOf(this_.allUserPermissions[i]) != -1) {
          bundleNames.push(this_.allApplicationPermissions[j].bundleName);
        }
      }
      var pa: permissionApplications = {
        'permission': this_.allUserPermissions[i],
        'groupName': permissionGroup.name,
        'bundleNames': bundleNames,
        'icon': icon
      };
      this_.allPermissionApplications.push(pa);
    }
  }

  /**
   * Get permission group information
   */
  getAllGroupPermission() {
    const this_ = this;
    var temp1 = [];
    temp1 = ["LOCATION","CAMERA","MICROPHONE","MEDIA","CALENDAR","SPORT","HEALTH"];
    groups.forEach((item) => {
      if (temp1.indexOf(item.name) > -1) {
        var gp: groupPermission = {
          "group": item.name,
          "permissions": item.permissions,
          'groupName': item.groupName,
          'icon': item.icon,
          'isShow': item.isShow
        };
        this_.allGroupPermission.push(gp);
      }
    })
    let temp2 = [];
    groups.forEach((item) => {
      if (item.isShow && temp1.indexOf(item.name) === -1) {
        var gp: groupPermission = {
          "group": item.name,
          "permissions": item.permissions,
          'groupName': item.groupName,
          'icon': item.icon,
          'isShow': item.isShow
        };
        temp2.push(item.name);
        this_.allGroupPermission.push(gp);
      }
    })
    for (let i = 0; i < this_.allPermissionApplications.length; i++) {
        if (this_.allGroups.indexOf(this_.allPermissionApplications[i].groupName) == -1
        && temp1.indexOf(this_.allPermissionApplications[i].groupName) == -1) {
          this_.allGroups.push(this_.allPermissionApplications[i].groupName);
        }
    }
    // Permission layout
    var temp = this_.allGroups;
    temp = temp.filter(function(item) {
      return temp1.indexOf(item) == -1 && temp2.indexOf(item) == -1;
    });
    if (temp.indexOf("OTHER") > -1) {
      temp.splice(temp.indexOf("OTHER"),1);
      temp.push("OTHER");
    }else {
      temp.push("OTHER");
    }
    this_.allGroups = temp;
    for (let i = 0; i < this_.allGroups.length; i++) {
      var permissions: string[] = permissionGroupPermissions[this_.allGroups[i]];
      var gp: groupPermission = {
        "group": this_.allGroups[i],
        "permissions": permissions,
        'groupName': '',
        'icon': '',
        'isShow': false
      };
      this_.allGroupPermission.push(gp);
    }
    this.allGroupPermission.forEach((ele) => {
      groups.forEach((item) => {
        if (ele.group === item.name) {
          ele.groupName = item.groupName;
          ele.icon = item.icon;
          ele.isShow = item.isShow;
        }
      });
    })
  }

  /**
   * Deduplicate permission information and permission group information
   * @param {Object} info bundleInfos Application Information
   * @param {Array} allPermissions All permissions
   * @param {Array} allApplicationPermissions All permissions apply
   */
  async deduplicationPermissions(info, allPermissions, allApplicationPermissions) {
    var reqPermissionsLen = info.reqPermissions.length;
    var reqUserPermissions: string[] = [];
    var acManager = abilityAccessCtrl.createAtManager()
    if (reqPermissionsLen > 0) {
      for (let j = 0; j < info.reqPermissions.length; j++) {
        var permission = info.reqPermissions[j];
        if((info.targetVersion < Constants.API_VERSION_SUPPORT_STAGE) && (permission == FUZZY_LOCATION_PERMISSION)) {
          continue
        }
        var flag = await acManager.getPermissionFlags(info.appInfo.accessTokenId, permission)
        if(flag == Constants.PRE_AUTHORIZATION_NOT_MODIFIED) {
          continue
        }
        if (allPermissions.indexOf(permission) == -1) {
          allPermissions.push(permission);
        }
        if (userGrantPermissions.indexOf(permission) != -1) {
          reqUserPermissions.push(permission);
        }
      }
    }
    let dePermissions = [];
    let groupIds = [];
    for (let i = 0; i < reqUserPermissions.length; i++) {
      if(dePermissions.indexOf(groups[permissionGroupIds[reqUserPermissions[i]]].name) == -1){
        dePermissions.push(groups[permissionGroupIds[reqUserPermissions[i]]].name);
      }
      if(groupIds.indexOf(permissionGroupIds[reqUserPermissions[i]]) == -1){
        groupIds.push(permissionGroupIds[reqUserPermissions[i]]);
      }
    }

    // adapt different api
    if (info.compatibleVersion >= API_VERSION_SUPPORT_STAGE) {
      info.appInfo.iconId = info.hapModuleInfos[0].abilityInfo[0].iconId;
    }

    var ap: applicationPermissions = {
      'bundleName': info.name,
      'api': info.targetVersion,
      'tokenId': info.appInfo.accessTokenId,
      'iconId': info.appInfo.iconId,
      'labelId': info.appInfo.labelId,
      'permissions': reqUserPermissions,
      'groupId': groupIds
    };
    allApplicationPermissions.push(ap);
  }

  /**
   * Get app name resource
   * @param {Number} index index of all app permissions array
   * @param {String} bundleName Package names
   * @param {String} labelName Application Name
   */
  updateAppLabel(index, bundleName, labelName) {
    let context = globalThis.context.createBundleContext(bundleName)
    if (index >= this.allApplicationPermissions.length) {
      return;
    }
    var info = this.allApplicationPermissions[index];
    context.resourceManager.getString(info.labelId, (error, value) => {
      if (value == undefined) {
        info.labelId = labelName;
      } else {
        info.labelId = value;
      }
    })
  }

  /**
   * Get app icon resources
   * @param {Number} index index of all app permissions array
   * @param {String} bundleName Package names
   */
  updateAppIcon(index, bundleName) {
    let context = globalThis.context.createBundleContext(bundleName)
    if (index >= this.allApplicationPermissions.length) {
      return;
    }
    var info = this.allApplicationPermissions[index];
    context.resourceManager.getMediaBase64(info.iconId, (error, value) => {
      info.iconId = value;
    })
  }

  /**
   * Lifecycle function, executed when the page is initialized
   */
  aboutToAppear() {
    console.log(TAG + 'on aboutToAppear, version 1.01');
    this.getAllBundlePermissions(this.allPermissions, this.allApplicationPermissions);
    globalThis.context.resourceManager.getString($r("app.string.textInput_placeholder").id).then(val => {
      textInput_placeholder = val
    })
  }

  getPermissionGroup(allGroup, order) {
    var fixedName: string[] = ['LOCATION', 'CAMERA', 'MICROPHONE']
    var fixedGroup: any[] = []
    var changeGroup: any[] = []
    var otherGroup: any[] = []

    allGroup.forEach(group => {
      if(fixedName.indexOf(group.group) !== -1) {
        fixedGroup.push(group)
      }else if(group.group == 'OTHER') {
        otherGroup.push(group)
      }else {
        changeGroup.push(group)
      }
    })

    if(order == Constants.FIXED_GROUP){
      return fixedGroup
    }else if(order == Constants.CHANGE_GROUP) {
      return changeGroup
    }else if(order == Constants.OTHER_GROUP) {
      return otherGroup
    }
  }

  build() {
    GridContainer({ gutter: Constants.GUTTER, margin: Constants.GRID_MARGIN }) {
      Row() {
        Row()
          .useSizeType({
            xs: { span: Constants.LEFT_XS_SPAN, offset: Constants.LEFT_XS_OFFSET },
            sm: { span: Constants.LEFT_SM_SPAN, offset: Constants.LEFT_SM_OFFSET },
            md: { span: Constants.LEFT_MD_SPAN, offset: Constants.LEFT_MD_OFFSET },
            lg: { span: Constants.LEFT_LG_SPAN, offset: Constants.LEFT_LG_OFFSET }
          })
          .height(Constants.FULL_HEIGHT)
        Row() {
          Column() {
            Row() {
              backBar( { title: JSON.stringify($r('app.string.authority_management')), recordable: true })
            }
            Row() {
              Column() {
                Column() {
                  Stack() {
                    if(this.allGroupPermission.length) {
                      Tabs() {
                        TabContent() {
                          Row() {
                            Column() {
                              Scroll() {
                                Column() {
                                  List() {
                                    ListItem() {
                                      List() {
                                        ForEach(this.getPermissionGroup(this.allGroupPermission, Constants.FIXED_GROUP).slice(Constants.SLICE_START,
                                          this.getPermissionGroup(this.allGroupPermission, Constants.FIXED_GROUP).length - 1), (item) => {
                                          this.ListItemLayout(item, Constants.SLICE_START_INDEX)
                                        }, item => item.toString())
                                        ForEach(this.getPermissionGroup(this.allGroupPermission, Constants.FIXED_GROUP).slice(Constants.SLICE_END), (item) => {
                                          this.ListItemLayout(item, Constants.SLICE_END_INDEX)
                                        }, item => item.toString())
                                      }.backgroundColor($r('app.color.default_background_color'))
                                      .borderRadius(Constants.BORDER_RADIUS)
                                      .padding({ top: Constants.LIST_PADDING_TOP, bottom: Constants.LIST_PADDING_BOTTOM })
                                      .margin({ bottom: Constants.LIST_MARGIN_BOTTOM })
                                    }

                                    ListItem() {
                                      List() {
                                        ForEach(this.getPermissionGroup(this.allGroupPermission, Constants.CHANGE_GROUP).slice(Constants.SLICE_START,
                                          this.getPermissionGroup(this.allGroupPermission, Constants.CHANGE_GROUP).length - 1), (item) => {
                                          this.ListItemLayout(item, Constants.SLICE_START_INDEX)
                                        }, item => item.toString())
                                        ForEach(this.getPermissionGroup(this.allGroupPermission, Constants.CHANGE_GROUP).slice(Constants.SLICE_END), (item) => {
                                          this.ListItemLayout(item, Constants.SLICE_END_INDEX)
                                        }, item => item.toString())
                                      }.backgroundColor($r('app.color.default_background_color'))
                                      .borderRadius(Constants.BORDER_RADIUS)
                                      .padding({ top: Constants.LIST_PADDING_TOP, bottom: Constants.LIST_PADDING_BOTTOM })
                                      .margin({ bottom: Constants.LIST_MARGIN_BOTTOM })
                                    }

                                    ListItem() {
                                      List() {
                                        ForEach(this.getPermissionGroup(this.allGroupPermission, Constants.OTHER_GROUP), (item) => {
                                          this.ListItemLayout(item, Constants.SLICE_END_INDEX)
                                        }, item => item.toString())
                                      }.backgroundColor($r('app.color.default_background_color'))
                                      .borderRadius(Constants.BORDER_RADIUS)
                                      .padding({ top: Constants.LIST_PADDING_TOP, bottom: Constants.LIST_PADDING_BOTTOM })
                                    }
                                  }.height(Constants.FULL_HEIGHT)
                                  .borderRadius(Constants.BORDER_RADIUS)
                                  .clip(true)
                                }.padding({
                                  left: Constants.MANAGEMENT_ROW_PADDING_LEFT,
                                  right: Constants.MANAGEMENT_ROW_PADDING_RIGHT,
                                })
                              }.scrollBar(BarState.Off)
                              .margin({ top: Constants.MANAGEMENT_ROW_PADDING_TOP })
                            }.width(Constants.FULL_WIDTH)
                          }
                        }.tabBar(this.TabBuilder(0))
                        TabContent() {
                          applicationItem()
                        }.tabBar(this.TabBuilder(1))
                      }
                      .barWidth(Constants.BAR_WIDTH)
                      .barMode(BarMode.Fixed)
                      .onChange((index) => {
                        this.currentIndex = index
                      })
                    }else {
                      LoadingProgress().width(Constants.LOADING_WIDTH)
                    }
                  }.height(Constants.FULL_HEIGHT)
                }
              }
            }
            .layoutWeight(Constants.LAYOUT_WEIGHT)
          }
        }
        .useSizeType({
          xs: { span: Constants.MIDDLE_XS_SPAN, offset: Constants.MIDDLE_XS_OFFSET },
          sm: { span: Constants.MIDDLE_SM_SPAN, offset: Constants.MIDDLE_SM_OFFSET },
          md: { span: Constants.MIDDLE_MD_SPAN, offset: Constants.MIDDLE_MD_OFFSET },
          lg: { span: Constants.MIDDLE_LG_SPAN, offset: Constants.MIDDLE_LG_OFFSET }
        })
        .height(Constants.FULL_HEIGHT)
        Row()
          .useSizeType({
            xs: { span: Constants.RIGHT_XS_SPAN, offset: Constants.RIGHT_XS_OFFSET },
            sm: { span: Constants.RIGHT_SM_SPAN, offset: Constants.RIGHT_SM_OFFSET },
            md: { span: Constants.RIGHT_MD_SPAN, offset: Constants.RIGHT_MD_OFFSET },
            lg: { span: Constants.RIGHT_LG_SPAN, offset: Constants.RIGHT_LG_OFFSET }
          })
          .height(Constants.FULL_HEIGHT)
      }
      .height(Constants.FULL_HEIGHT)
      .width(Constants.FULL_WIDTH)
      .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
      .opacity(Constants.MANAGEMENT_TRANSPARENCY)
    }
  }
}

@Component
struct applicationItem {
  @State applicationItem: any[] = bundleInfosList // application info array
  @State oldApplicationItem: any[] = bundleInfosList // Original application information array
  @State searchResult: boolean = true // search results

  @Builder ListItemLayout(item, index) {
    ListItem() {
      Row() {
        Column() {
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Row() {
              Image(item.iconId)
                .customizeImage(Constants.APPLICATION_IMAGE_WIDTH, Constants.APPLICATION_IMAGE_HEIGHT)
                .margin({ right: Constants.APPLICATION_IMAGE_MARGIN_RIGHT })
              Text(item.labelId)
                .fontSize(Constants.TEXT_MIDDLE_FONT_SIZE)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.label_color'))
                .flexGrow(Constants.FLEX_GROW)
              Text(item.groupId.length + '项权限')
                .fontSize(Constants.TEXT_SMAL_FONT_SIZE)
                .fontColor($r('app.color.label_color_lighter'))
                .margin({ right: Constants.APPLICATION_TEXT_MARGIN_RIGHT })
              Image($r('app.media.rightarrow'))
                .customizeImage(Constants.IMAGE_WIDTH, Constants.IMAGE_HEIGHT)
            }
            .width(Constants.FULL_WIDTH)
            .height(Constants.AUTHORITY_ROW_HEIGHT)
            .constraintSize({ minHeight: Constants.AUTHORITY_CONSTRAINTSIZE_MINHEIGHT })
          }
          if (!index) {
            Row() {
              Flex() {
                Column().width(Constants.APPLICATION_TEXT_DECORATION_MARGIN_LEFT)
                Column()
                  .backgroundColor($r('app.color.text_decoration_color'))
                  .height(Constants.TEXT_DECORATION_HEIGHT)
                  .flexGrow(Constants.FLEX_GROW)
              }
            }
          }
        }.onClick(() => {
          router.push({
            uri: 'pages/application-secondary',
            params: { routerData: item }
          });
        })
      }
    }.padding({
      left: Constants.DEFAULT_PADDING_START,
      right: Constants.DEFAULT_PADDING_END
    })
  }

  build() {
    Column() {
      Row() {
        textInput({
          placeholder: String(textInput_placeholder),
          applicationItem: $applicationItem,
          oldApplicationItem: $oldApplicationItem,
          searchResult: $searchResult
        })
      }.padding({
        left: Constants.APPLICATION_TEXTINPUT_PADDING_LEFT,
        top: Constants.APPLICATION_TEXTINPUT_PADDING_TOP,
        right: Constants.APPLICATION_TEXTINPUT_PADDING_RIGHT
      })
      Row() {
        Flex({ alignItems: ItemAlign.Start }) {
          Column() {
            Column() {
              if (!this.applicationItem.length) {
                Row() {
                  Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                    Image($r('app.media.searchnoresult'))
                      .customizeImage(Constants.SEARCHNORESULT_IMAGE_WIDTH, Constants.SEARCHNORESULT_IMAGE_HEIGHT)
                  }
                }.margin({ top: Constants.MANAGEMENT_ROW_MARGIN_TOP })
                .padding({ left: Constants.MANAGEMENT_ROW_PADDING_LEFT })
              } else {
                Row() {
                  Scroll() {
                    List() {
                      ForEach(this.applicationItem.slice(Constants.SLICE_START, this.applicationItem.length - 1),
                        (item) => {
                          this.ListItemLayout(item, Constants.SLICE_START_INDEX)
                        }, item => item.toString())
                      ForEach(this.applicationItem.slice(Constants.SLICE_END), (item) => {
                        this.ListItemLayout(item, Constants.SLICE_END_INDEX)
                      }, item => item.toString())
                    }.backgroundColor($r('app.color.default_background_color'))
                    .borderRadius(Constants.BORDER_RADIUS)
                    .padding({ top: Constants.LIST_PADDING_TOP, bottom: Constants.LIST_PADDING_BOTTOM })
                  }.scrollBar(BarState.Off)
                }.margin({ left: Constants.MANAGEMENT_ROW_PADDING_LEFT })
                .borderRadius(Constants.BORDER_RADIUS)
                .clip(true)
              }
            }.backgroundColor($r('app.color.background_color'))
            .height(Constants.FULL_HEIGHT)
          }.margin({ top: Constants.MANAGEMENT_ROW_MARGIN_TOP, bottom: Constants.APPLICATION_LIST_MARGIN_BOTTOM })
          Column() {
            alphabetIndexerComponent({ applicationItem: $applicationItem, oldApplicationItem: $oldApplicationItem })
          }.margin({ top: Constants.APPLICATION_ALPHABETINDEX_MARGIN_TOP })
          .width(Constants.APPLICATION_ALPHABETINDEX_WIDTH)
        }
      }
    }
  }
}
