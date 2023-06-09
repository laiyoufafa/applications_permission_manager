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
import router from '@system.router';
import bundle from "@ohos.bundle";
import { getAppLabel, getAppIcon } from "../common/utils/utils";
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { authorizeDialog } from "../common/components/dialog";
import { permissionGroups, showSubpermissionsGrop, polymorphismGroup } from "../common/model/permissionGroup";
import Constants from '../common/utils/constant';

var TAG = 'PermissionManager_MainAbility:'

let routerData: any = router.getParams().routerData; // Routing jump data
let backTitle: any = router.getParams().backTitle; // return title name
let status = router.getParams().status; // Status: Allowed, Forbidden
let permissions: any = router.getParams().permission; // permissions name
let nowGrantResult = Constants.PERMISSION_NUM; // Authorization results now
let nowRevokeResult = Constants.PERMISSION_NUM; // Now deauthorize results
let GrantResultFlag = []; // Authorization result Flag
let RevokeResultFlag = []; // Cancel authorization result Flag
let reason = null  // Authorized reason
let bundleInfo: any = {}
const PRECISE_LOCATION_PERMISSION = 'ohos.permission.LOCATION'
class MeidaDocObj {
  name: Resource
  index: number
  groupName: string
  accessTokenId: number
  permissions: []
  constructor(
    name: Resource,
    index: number,
    groupName: string,
    accessTokenId: number,
    permissions: []
  ) {
    this.name = name
    this.index = index
    this.groupName = groupName
    this.accessTokenId = accessTokenId
    this.permissions = permissions
  }
}; // permission information class
class MediaListObj {
  labelId: string
  iconId: string
  versionName: string
  constructor(labelId: string, iconId: string, versionName: string,) {
    this.labelId = labelId
    this.iconId = iconId
    this.versionName = versionName
  }
}; // Permission application information class

@Entry
@Component
struct mediaDocumentPage {
  build() {
    Column() {
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
                backBar({ title: JSON.stringify(backTitle), recordable: false })
              }
              Row() {
                Column() {
                  mediaDocumentItem()
                }.width(Constants.FULL_WIDTH)
              }
              .margin({ top: Constants.TITLE_MARGIN_BOTTOM })
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
}

@Component
struct mediaDocumentItem {
  @State mediaDocListItem: MeidaDocObj[] = []; // Permission information array
  @State mediaListItem: MediaListObj = {
    labelId: '',
    iconId: '',
    versionName: '',
  }; // application info array
  @State isCheckList: boolean[] = []; // Permission status array
  @State accurateIsOn: boolean = true;
  @State api: number = 0;

  authorizeDialogController: CustomDialogController = new CustomDialogController({
    builder: authorizeDialog({ }),
    autoCancel: true,
    alignment: DialogAlignment.Center
  });

  /**
   * Grant permissions to the app
   * @param {Number} accessTokenId
   * @param {String} permission permission name
   */
  grantUserGrantedPermission(accessTokenId, permission) {
    abilityAccessCtrl.createAtManager().grantUserGrantedPermission(
      accessTokenId, permission, Constants.PERMISSION_FLAG).then((result) => {
      nowGrantResult = result;
    })
    .catch((error) => {
      console.error(TAG + 'grantUserGrantedPermission failed. Cause: ' + JSON.stringify(error));
    })
  }

  /**
   * Deauthorize the app
   * @param {Number} accessTokenId
   * @param {String} permission permission name
   */
  revokeUserGrantedPermission(accessTokenId, permission) {
    abilityAccessCtrl.createAtManager().revokeUserGrantedPermission(
      accessTokenId, permission, Constants.PERMISSION_FLAG).then((result) => {
      nowRevokeResult = result;
    })
      .catch((error) => {
        console.error(TAG + 'revokeUserGrantedPermission failed. Cause: ' + JSON.stringify(error));
      })
  }

  /**
   * Lifecycle function, executed when the page is initialized
   */
  aboutToAppear() {
    if(showSubpermissionsGrop.indexOf(globalThis.currentPermissionGroup) != -1) {
      reason = []
      permissions.forEach(permission => {
        permissionGroups.forEach(permissionGroup => {
          if(permissionGroup.permissionName == permission) {
            reason.push(permissionGroup.label)
          }
        })
      })
      Promise.all([globalThis.context.resourceManager.getString($r("app.string.separator").id),
      globalThis.context.resourceManager.getString($r("app.string.reason_suffix").id)])
        .then(values => {
          reason = reason.join(values[0]) + values[1]
        })
    }else {
      reason = ''
    }
    let hasReason = false
    bundle.getBundleInfo(routerData, Constants.PARMETER_BUNDLE_FLAG).then(res => {
      this.api = res.targetVersion
      bundleInfo = res
      permissions.forEach(permission => {
        res.reqPermissionDetails.forEach(reqPermissionDetail => {
          if(reqPermissionDetail.name == permission) {
            let context = globalThis.context.createBundleContext(routerData)
            context.resourceManager.getString(reqPermissionDetail.reasonId).then(value => {
                if (value !== undefined && !hasReason) {
                  reason += value.slice(Constants.START_SUBSCRIPT, Constants.END_SUBSCRIPT)
                  hasReason = true
                }
            })
          }
        })
      })
      var acManager = abilityAccessCtrl.createAtManager()
      acManager.verifyAccessToken(res.appInfo.accessTokenId, PRECISE_LOCATION_PERMISSION).then(accurateStatus => {
        accurateStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED ? this.accurateIsOn = true : this.accurateIsOn = false
      })
      Promise.all([getAppLabel(res.appInfo.labelId, res.name),
      getAppIcon(res.appInfo.iconId, res.name)])
        .then((values) => {
          this.mediaListItem = new MediaListObj(
            String(values[0]), String(values[1]), res.versionName);
        })
      this.mediaDocListItem.push(
        new MeidaDocObj(
          $r('app.string.allow'),
          Constants.RADIO_ALLOW_INDEX,
          Constants.RADIO_ALLOW_GROUP_NAME,
          res.appInfo.accessTokenId,
          permissions
        )
      );
      this.mediaDocListItem.push(
        new MeidaDocObj(
          $r('app.string.ban'),
          Constants.RADIO_BAN_INDEX,
          Constants.RADIO_BAN_GROUP_NAME,
          res.appInfo.accessTokenId,
          permissions
        )
      );
    }).catch((error) => {
      console.error(TAG + 'bundle.getBundleInfo failed. Cause: ' + JSON.stringify(error));
      this.mediaListItem = new MediaListObj('', '', '');
      this.mediaDocListItem.push(
        new MeidaDocObj($r('app.string.allow'), Constants.RADIO_ALLOW_INDEX,
          Constants.RADIO_ALLOW_GROUP_NAME, 0, permissions)
      );
      this.mediaDocListItem.push(
        new MeidaDocObj($r('app.string.ban'), Constants.RADIO_BAN_INDEX,
          Constants.RADIO_BAN_GROUP_NAME, 0, permissions)
      );
    })
    // Get permission status
    if (!status) {
      this.isCheckList = [true, false];
    } else {
      this.isCheckList = [false, true];
    }
  }

  build(){
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Image(this.mediaListItem.iconId)
            .width(Constants.TERTIARY_IMAGE_WIDTH)
            .height(Constants.TERTIARY_IMAGE_HEIGHT)
            .margin({ left: Constants.TERTIARY_IMAGE_MARGIN_LEFT, right: Constants.TERTIARY_IMAGE_MARGIN_RIGHT })
          Column() {
            Row() {
              Text(this.mediaListItem.labelId)
                .fontSize(Constants.TEXT_MIDDLE_FONT_SIZE)
                .fontColor($r('app.color.label_color'))
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Start)
            }
            .width(Constants.TERTIARY_HALF_WIDTH)
            .margin({ bottom: Constants.TERTIARY_LABEL_MARGIN_BOTTOM })
            Row() {
              Text(this.mediaListItem.versionName)
                .fontSize(Constants.TEXT_SMAL_FONT_SIZE)
                .fontColor($r('app.color.label_color_light'))
                .textAlign(TextAlign.Start)
            }
            .width(Constants.TERTIARY_HALF_WIDTH)
          }
        }.margin({ left: Constants.TERTIARY_MARGIN_LEFT })
      }
      if(reason) {
        Row() {
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Row() {
              Text(reason)
                .fontSize(Constants.TEXT_SMAL_FONT_SIZE)
                .fontColor($r('app.color.label_color_light'))
                .textAlign(TextAlign.Start)
            }.margin({ left: Constants.TERTIARY_IMAGE_MARGIN_LEFT, right: Constants.TERTIARY_IMAGE_MARGIN_RIGHT })
          }
        }
        .margin({ top: Constants.TERTIARY_ROW_MARGIN_TOP, left: Constants.TERTIARY_MARGIN_LEFT })
      }
      Row() {
        Text(backTitle)
          .fontSize(Constants.TEXT_SMAL_FONT_SIZE)
          .fontColor($r('app.color.label_color_light'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .lineHeight(Constants.SUBTITLE_LINE_HEIGHT)
        Text($r('app.string.access_permission'))
          .fontSize(Constants.TEXT_SMAL_FONT_SIZE)
          .fontColor($r('app.color.label_color_light'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .lineHeight(Constants.SUBTITLE_LINE_HEIGHT)
      }.width(Constants.FULL_WIDTH)
      .constraintSize({ minHeight: Constants.SUBTITLE_MIN_HEIGHT })
      .padding({ top: Constants.SUBTITLE_PADDING_TOP, bottom: Constants.SUBTITLE_PADDING_BOTTOM,
        left: Constants.TERTIARY_TEXT_MARGIN_LEFT, right: Constants.TERTIARY_IMAGE_MARGIN_RIGHT})
      .margin({ top: Constants.TERTIARY_PERMISSION_ROW_MARGIN_TOP })
      Column() {
        List() {
          ForEach(this.mediaDocListItem, (item) => {
            ListItem() {
              Column() {
                Row() {
                  Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                    Row() {
                      Text(item.name)
                        .fontSize(Constants.TEXT_MIDDLE_FONT_SIZE)
                        .fontColor($r('app.color.label_color'))
                        .fontWeight(FontWeight.Medium)
                        .flexGrow(Constants.FLEX_GROW)
                      if (this.isCheckList[item.index] === true) {
                        Shape() {
                          Circle().width(Constants.SHAPE_DIA).height(Constants.SHAPE_DIA)
                            .fill($r("app.color.shape_allow_color")).offset({ x: 0, y: 0 })
                          Circle().width(Constants.SHAPE_ALLOW_DIA).height(Constants.SHAPE_ALLOW_DIA)
                            .fill($r("app.color.default_background_color"))
                            .offset({ x: Constants.SHAPE_ALLOW_OFFSET, y: Constants.SHAPE_ALLOW_OFFSET })
                        }
                      } else if (this.isCheckList[item.index] === false) {
                        Shape() {
                          Circle().width(Constants.SHAPE_DIA).height(Constants.SHAPE_DIA)
                            .fill($r("app.color.shape_ban_color")).offset({ x: 0, y: 0 })
                          Circle().width(Constants.SHAPE_BAN_DIA).height(Constants.SHAPE_BAN_DIA)
                            .fill($r("app.color.default_background_color"))
                            .offset({ x: Constants.SHAPE_BAN_OFFSET, y: Constants.SHAPE_BAN_OFFSET })
                        }
                      }
                    }
                    .width(Constants.FULL_WIDTH)
                    .height(Constants.LISTITEM_ROW_HEIGHT)
                    .onClick(() => {
                        item.permissions.forEach((permission) => {
                          if (!item.index) {
                            if((this.api >= Constants.API_VERSION_SUPPORT_STAGE) && (permission == PRECISE_LOCATION_PERMISSION)) {
                              return false
                            }
                            this.grantUserGrantedPermission(item.accessTokenId, permission)
                            if (nowGrantResult != Constants.PERMISSION_INDEX) {
                              GrantResultFlag.push(-1)
                            }else{
                              GrantResultFlag.push(0)
                            }
                          } else {
                            if((permission == PRECISE_LOCATION_PERMISSION) && (this.api >= Constants.API_VERSION_SUPPORT_STAGE)) {
                              if(this.accurateIsOn) {
                                this.revokeUserGrantedPermission(item.accessTokenId, permission)
                                this.accurateIsOn = false
                              }
                            }else {
                              this.revokeUserGrantedPermission(item.accessTokenId, permission)
                            }

                            if (nowRevokeResult != Constants.PERMISSION_INDEX) {
                              RevokeResultFlag.push(-1)
                              this.authorizeDialogController.open();
                              setTimeout(()=> {
                                this.authorizeDialogController.close();
                              }, Constants.DELAY_TIME)
                            }else{
                              RevokeResultFlag.push(0)
                            }
                          }
                        })
                        if (!item.index) {
                          if(GrantResultFlag.indexOf(-1) > -1){
                            this.authorizeDialogController.open();
                            setTimeout(()=> {
                              this.authorizeDialogController.close();
                            }, Constants.DELAY_TIME)
                          }else{
                            this.isCheckList = [true, false];
                          }
                        }else{
                          if (RevokeResultFlag.indexOf(-1) > -1){
                            this.authorizeDialogController.open();
                            setTimeout(()=> {
                              this.authorizeDialogController.close();
                            }, Constants.DELAY_TIME)
                          }else{
                            this.isCheckList = [false, true];
                          }
                        }
                    })
                  }
                }
                if (!item.index) {
                  Row() {
                    Column()
                      .backgroundColor($r('app.color.text_decoration_color'))
                      .width(Constants.FULL_WIDTH)
                      .height(Constants.TEXT_DECORATION_HEIGHT)
                  }
                }
              }
              .onClick(() => {
              })
            }
            .padding({
              left: Constants.DEFAULT_PADDING_START,
              right: Constants.DEFAULT_PADDING_END
            })
            .margin({ top: Constants.TERTIARY_LISTITEM_MARGIN_TOP })
          }, item => item.toString())
        }
        .borderRadius(Constants.BORDER_RADIUS)
        .backgroundColor($r('app.color.default_background_color'))
        .padding({
          top: Constants.TERTIARY_LIST_PADDING_TOP, bottom: Constants.TERTIARY_LIST_PADDING_BOTTOM
        })

        if ((this.api >= Constants.API_VERSION_SUPPORT_STAGE) && (permissions.includes(PRECISE_LOCATION_PERMISSION))) {
          Column() {
            Row() {
              Text($r('app.string.precise_location'))
                .fontSize(Constants.TEXT_MIDDLE_FONT_SIZE)
                .fontColor($r('app.color.label_color'))
                .fontWeight(FontWeight.Medium)
                .flexGrow(Constants.FLEX_GROW)
              Toggle({ type: ToggleType.Switch, isOn: this.accurateIsOn })
                .selectedColor($r('app.color.button_color'))
                .switchPointColor($r('app.color.selected_Color'))
                .onChange((isOn: boolean) => {
                  var acManager = abilityAccessCtrl.createAtManager()
                  if (isOn) {
                    acManager.grantUserGrantedPermission(bundleInfo.appInfo.accessTokenId, PRECISE_LOCATION_PERMISSION, Constants.PERMISSION_FLAG)
                      .then((res) => { res == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED ? this.accurateIsOn = true : this.accurateIsOn = false })
                      .catch(() => { this.accurateIsOn = false })
                  } else {
                    acManager.revokeUserGrantedPermission(bundleInfo.appInfo.accessTokenId, PRECISE_LOCATION_PERMISSION, Constants.PERMISSION_FLAG)
                      .then(() => { this.accurateIsOn = false })
                      .catch(() => { this.accurateIsOn = true })
                  }
                })
                .padding({ right: 0 })
                .enabled(this.isCheckList[0])
            }.width(Constants.FULL_WIDTH)
            .height(Constants.LISTITEM_ROW_HEIGHT)
          }.margin({ top: Constants.LOCATION_MARGIN_TOP, bottom: Constants.LOCATION_MARGIN_BOTTOM })
          .padding({
            left: Constants.DEFAULT_PADDING_START,
            right: Constants.DEFAULT_PADDING_END,
            top: Constants.TERTIARY_LIST_PADDING_TOP,
            bottom: Constants.TERTIARY_LIST_PADDING_BOTTOM
          })
          .borderRadius(Constants.BORDER_RADIUS)
          .backgroundColor($r('app.color.default_background_color'))

          Row() {
            Text($r('app.string.get_the_exact_position'))
              .fontSize(Constants.TEXT_SMAL_FONT_SIZE)
              .fontColor($r('app.color.label_color_light'))
              .lineHeight(Constants.TEXT_SMALL_LINE_HEIGHT)
          }.width(Constants.FULL_WIDTH)
          .padding({
            left: Constants.DEFAULT_PADDING_START,
            right: Constants.DEFAULT_PADDING_END,
          })
        }
      }
      .padding({
        left: Constants.LIST_PADDING_LEFT,
        right: Constants.LIST_PADDING_LEFT
      })
      .width(Constants.FULL_WIDTH)
      .height(Constants.FULL_HEIGHT)
    }
    .width(Constants.FULL_WIDTH)
  }
}
