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

import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import bundle from '@ohos.bundle';
import rpc from '@ohos.rpc';
import { Log, getPermissionGroup } from '../common/utils/utils'
import Constants from '../common/utils/constant'
import { BundleFlag } from '../common/model/bundle'
import { permissionGroups, showSubpermissionsGrop } from '../common/model/permissionGroup'
import { LocationCanvas } from '../common/components/location'

@Extend(Button) function customizeButton() {
  .backgroundColor($r('app.color.default_background_color'))
  .fontColor($r('app.color.button_color'))
  .fontWeight(FontWeight.Medium)
  .height(Constants.BUTTON_HEIGHT)
  .width(Constants.BUTTON_WIDTH)
}

const FUZZY_LOCATION_PERMISSION = 'ohos.permission.APPROXIMATELY_LOCATION'
const PRECISE_LOCATION_PERMISSION = 'ohos.permission.LOCATION'

@Entry
@Component
struct dialogPlusPage {
  privacyDialogController: CustomDialogController = new CustomDialogController({
    builder: PermissionDialog(),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  build() {}

  aboutToAppear() {
    this.privacyDialogController.open()
  }
}

@CustomDialog
struct PermissionDialog {
  @State count: number = 0
  @State result: Array<any> = []
  @State accessTokenId: number = 0
  @State initStatus: number = Constants.INIT_NEED_TO_WAIT
  @State reqPerms: Array<string> = []
  @State grantGroups: Array<any> = []
  @State userFixedFlag: number = 2 // means user fixed
  @State appName: string = ""
  @State win: any = ""
  @State proxy: any = ''
  @State locationFlag: number = Constants.LOCATION_NONE
  @State resource: any = {}
  @State bundleInfo: any = {}
  controller: CustomDialogController

  build() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {
        if ((this.initStatus != Constants.INIT_NEED_TO_WAIT) && this.verify()) {
          Image(this.grantGroups[this.count].icon)
            .width(Constants.DIALOG_ICON_WIDTH)
            .height(Constants.DIALOG_ICON_HEIGHT)
            .fillColor($r("app.color.first_font_color"))
            .margin({
              top: Constants.DIALOG_ICON_MARGIN_TOP
            })
          Text(`${this.count + 1} / ${this.grantGroups.length}`)
            .fontSize(Constants.DIALOG_LABEL_FONT_SIZE)
            .fontColor($r('app.color.text_secondary_color'))
            .lineHeight(Constants.DIALOG_LABEL_LINE_HEIGHT)
            .margin({
              top: Constants.DIALOG_LABEL_MARGIN_TOP
            })
          Column() {
            Row() {
              Flex({ justifyContent: FlexAlign.Start }) {
                Text(this.showTitle())
                  .fontSize(Constants.DIALOG_REQ_FONT_SIZE)
                  .fontColor($r('app.color.first_font_color'))
                  .fontWeight(FontWeight.Medium)
                  .fontSize(Constants.DIALOG_REQ_FONT_SIZE)
                  .lineHeight(Constants.DIALOG_REQ_LINE_HEIGHT)
                  .margin({
                    top: Constants.DIALOG_REQ_MARGIN_TOP,
                    left: Constants.DIALOG_REQ_MARGIN_LEFT,
                    right: Constants.DIALOG_REQ_MARGIN_RIGHT
                  })
              }
            }

            Row() {
              Flex({ justifyContent: FlexAlign.Start }) {
                Text(this.showReason())
                  .fontSize(Constants.DIALOG_DESP_FONT_SIZE)
                  .fontColor($r('app.color.text_secondary_color'))
                  .fontSize(Constants.DIALOG_DESP_FONT_SIZE)
                  .lineHeight(Constants.DIALOG_DESP_LINE_HEIGHT)
                  .margin({
                    top: Constants.DIALOG_DESP_MARGIN_TOP,
                    left: Constants.DIALOG_DESP_MARGIN_LEFT,
                    right: Constants.DIALOG_DESP_MARGIN_RIGHT,
                    bottom: Constants.DIALOG_DESP_MARGIN_BOTTOM
                  })
              }
            }

            if(this.locationFlag > Constants.LOCATION_NONE) {
              LocationCanvas({ locationFlag: $locationFlag })
            }
          }
        }
        Row() {
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Button($r('app.string.ban'))
              .fontSize(Constants.BUTTON_FONT_SIZE)
              .onClick(() => {
                this.privacyCancel(this.grantGroups[this.count], this.accessTokenId, this.reqPerms, this.userFixedFlag)
              }).customizeButton().margin({ left: Constants.BUTTON_MARGIN_LEFT })
            Text('|').fontSize(Constants.BUTTON_DIVIDER_FONT_SIZE).fontColor($r('app.color.divider_color'))
            Button($r('app.string.allow'))
              .fontSize(Constants.BUTTON_FONT_SIZE)
              .onClick(() => {
                this.privacyAccept(this.grantGroups[this.count], this.accessTokenId, this.reqPerms, this.userFixedFlag)
              }).customizeButton().margin({ right: Constants.BUTTON_MARGIN_RIGHT })
          }
        }
      }
      .backgroundColor($r('app.color.default_background_color'))
      .borderRadius(Constants.DIALOG_PRIVACY_BORDER_RADIUS)
      .width(Constants.DIALOG_PRIVACY_WIDTH)
      .padding({ bottom: Constants.DIALOG_PADDING_BOTTOM })
    }.width(Constants.FULL_WIDTH)
    .height(Constants.FULL_HEIGHT)
  }

  showTitle() {
    if(this.grantGroups[this.count].name == 'LOCATION') {
      if(this.locationFlag == Constants.LOCATION_FUZZY) {
        return this.resource.whether_to_allow + this.appName + this.resource.access_general_location
      }
      if(this.locationFlag == Constants.LOCATION_UPGRADE) {
        return this.resource.whether_to_allow + this.appName + this.resource.fuzzy_to_exact
      }
    }
    return this.resource.whether_to_allow + this.appName + this.grantGroups[this.count].label
  }

  showReason() {
    if(this.grantGroups[this.count].name == 'LOCATION') {
      if((this.locationFlag == Constants.LOCATION_FUZZY) || (this.locationFlag == Constants.LOCATION_BOTH_FUZZY)) {
        return $r('app.string.close_exact_position')
      }
    }
    return this.grantGroups[this.count].description
  }

  verify() {
    if((this.initStatus == Constants.INIT_NEED_TO_TERMINATED) || (this.count >= this.grantGroups.length)) {
      this.answerRequest()
      this.initStatus = Constants.INIT_NEED_TO_WAIT
      return false
    }
    return true
  }

  answerRequest() {
    var ret: number = Constants.RESULT_SUCCESS
    if (this.initStatus == Constants.INIT_NEED_TO_TERMINATED) {
      ret = Constants.RESULT_FAILURE
    }
    this.answer(ret, this.reqPerms)
  }

  answer(ret, reqPerms) {
    Log.info("code:" + ret + ", perms="+ JSON.stringify(reqPerms) +", result=" + JSON.stringify(this.result))
    var perms = []
    var results = []
    reqPerms.forEach(perm => {
      perms.push(perm)
    })
    this.result.forEach(result => {
      results.push(result)
    })
    let option = new rpc.MessageOption()
    let data = new rpc.MessageParcel()
    let reply = new rpc.MessageParcel()
    Promise.all([data.writeInterfaceToken(Constants.ACCESS_TOKEN),
      data.writeStringArray(perms),
      data.writeIntArray(results)
    ]).then(() => {
      this.proxy.sendRequest(Constants.RESULT_CODE, data, reply, option)
      this.destruction()
    }).catch(() => {
      Log.error('write result failed!')
      this.destruction()
    })
  }

  destruction() {
    this.win.destroy()
    globalThis.windowNum --
    Log.info("windowNum:" + globalThis.windowNum)
    if(globalThis.windowNum == 0) {
      globalThis.extensionContext.terminateSelf()
    }
  }

  async privacyAccept(group, accessTokenId, permissionList, userFixedFlag) {
    var acManager = abilityAccessCtrl.createAtManager()
    var num = 0
    group.permissions.forEach(async permission => {
      let result
      if(showSubpermissionsGrop.indexOf(group.name) == -1) {
        if(group.name == 'LOCATION' && this.bundleInfo.targetVersion >= Constants.API_VERSION_SUPPORT_STAGE) {
          if(!(((this.locationFlag == Constants.LOCATION_BOTH_FUZZY) || (this.locationFlag == Constants.LOCATION_FUZZY))
            && (permission == PRECISE_LOCATION_PERMISSION))) {
            result = await acManager.grantUserGrantedPermission(accessTokenId, permission, userFixedFlag)
          }
        }else {
          result = await acManager.grantUserGrantedPermission(accessTokenId, permission, userFixedFlag)
        }
      }else {
        if(permissionList.includes(permission)) {
          result = await acManager.grantUserGrantedPermission(accessTokenId, permission, userFixedFlag)
        }
      }
      num ++
      Log.info("grant permission result:" + result + "permission" + permission)
      if (result == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        permissionList.forEach((req, idx) => {
          if(req == permission) {
            this.result[idx] = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
          }
        })
        Log.info("grant permission success:" + permission)
      } else {
        Log.error("failed to grant permission:" + permission + " ret:" + result)
      }
      if(num == group.permissions.length) {
        this.count ++
      }
    })
  }

  async privacyCancel(group, accessTokenId, permissionList, userFixedFlag) {
    var acManager = abilityAccessCtrl.createAtManager()
    group.permissions.forEach(async permission => {
      let result
      if(showSubpermissionsGrop.indexOf(group.name) == -1) {
        result = await acManager.revokeUserGrantedPermission(accessTokenId, permission, userFixedFlag)
      }else {
        if(permissionList.includes(permission)) {
          result = await acManager.revokeUserGrantedPermission(accessTokenId, permission, userFixedFlag)
        }
      }
      Log.info("revoke permission result:" + result + "permission" + permission);
    })
    this.count ++
  }

  getgrantGroups(stateGroup) {
    //Processing of positioning
    if(this.bundleInfo.targetVersion >= Constants.API_VERSION_SUPPORT_STAGE) {
      if(this.reqPerms.includes(FUZZY_LOCATION_PERMISSION)) {
        this.locationFlag = Constants.LOCATION_FUZZY
        if(this.reqPerms.includes(PRECISE_LOCATION_PERMISSION)) {
          this.locationFlag = Constants.LOCATION_BOTH_PRECISE
          var fuzzyIndex = this.reqPerms.indexOf(FUZZY_LOCATION_PERMISSION)
          if(stateGroup[fuzzyIndex] == Constants.PASS_OPER) {
            this.locationFlag = Constants.LOCATION_UPGRADE
          }
        }
      }
    }

    this.reqPerms.forEach((permission, idx) => {
      //已授权
      if(stateGroup[idx] == Constants.PASS_OPER) {
        Log.info("permission has been fixed:" + permission)
        this.result[idx] = abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
        //待授权
      }else if(stateGroup[idx] == Constants.DYNAMIC_OPER) {
        var group = getPermissionGroup(permission)
        if(!group) {
          Log.info("permission not find:" + permission)
        }else {
          var exist = this.grantGroups.find(grantGroup => grantGroup.name == group.name)
          //判断是否为需要展示子权限的权限组
          if(showSubpermissionsGrop.indexOf(group.name) != -1) {
            var permissionDetail
            permissionGroups.forEach(permissionGroup => {
              if(permissionGroup.permissionName == permission) {
                //获取授权的权限信息
                permissionDetail = permissionGroup
              }
            })
            //权限组已存在的情况
            if(!exist) {
              group.description = [permissionDetail.label]
              this.grantGroups.push(group)
            }else {
              if(exist.description.indexOf(permissionDetail.label) == -1) {
                exist.description.push(permissionDetail.label)
              }
            }
          }else {
            if(!exist) {
              this.grantGroups.push(group)
            }
          }
        }
      }
    })
    this.initStatus = Constants.INIT_NEED_TO_VERIFY
  }

  getApplicationName(bundleName, uid) {
    Log.info("getApplicationName bundleName:" + bundleName)
    Log.info("getApplicationName userId:" + Math.floor(uid/200000))
    bundle.getApplicationInfo(bundleName, BundleFlag.GET_BUNDLE_DEFAULT, Math.floor(uid/200000)).then(applicationInfo => {
      let context = globalThis.extensionContext.createBundleContext(bundleName)
      context.resourceManager.getString(applicationInfo.labelId, (err, value) => {
        if (value == undefined) {
          this.appName = applicationInfo.label
        } else {
          this.appName = value
        }
        Log.info("hap label:" + applicationInfo.label + ", value:"+this.appName)
      })
    }).catch(err => {
      Log.error("applicationInfo error :" + err)
      this.initStatus = Constants.INIT_NEED_TO_TERMINATED
    })
    this.grantGroups.forEach((group) => {
      if(group.description) {
        Promise.all([globalThis.extensionContext.resourceManager.getString($r("app.string.separator").id),
        globalThis.extensionContext.resourceManager.getString($r("app.string.reason_suffix").id)])
          .then(values => {
            group.description = group.description.join(values[0]) + values[1]
            this.getReason(group, this.bundleInfo, bundleName)
          })
      }else {
        this.getReason(group, this.bundleInfo, bundleName)
      }
    })
  }

  getReason(group, bundleInfo, bundleName) {
    group.permissions.forEach(permission => {
      if(this.reqPerms.indexOf(permission) != -1) {
        bundleInfo.reqPermissionDetails.forEach(reqPermissionDetail => {
          if(reqPermissionDetail.name == permission) {
            let context = globalThis.extensionContext.createBundleContext(bundleName)
            context.resourceManager.getString(reqPermissionDetail.reasonId, (err, value) => {
              this.initStatus = Constants.INIT_NEED_TO_REFRESH
              if (value !== undefined && !group.hasReason) {
                group.description += value.slice(Constants.START_SUBSCRIPT, Constants.END_SUBSCRIPT)
                group.hasReason = true
              }
            })
          }
        })
      }
    })
  }

  getStrings() {
    globalThis.extensionContext.resourceManager.getString($r("app.string.whether_to_allow").id, (err, val) => {
      this.resource.whether_to_allow = val
    })
    globalThis.extensionContext.resourceManager.getString($r("app.string.access_general_location").id, (err, val) => {
      this.resource.access_general_location = val
    })
    globalThis.extensionContext.resourceManager.getString($r("app.string.fuzzy_to_exact").id, (err, val) => {
      this.resource.fuzzy_to_exact = val
    })
  }

  aboutToAppear() {
    this.count = 0;
    this.initStatus = Constants.INIT_NEED_TO_WAIT
    this.result = []
    this.reqPerms = globalThis.abilityWant.parameters['ohos.user.grant.permission']
    this.accessTokenId = globalThis.abilityWant.parameters['ohos.aafwk.param.callerToken']
    this.proxy = globalThis.abilityWant.parameters['ohos.ability.params.callback'].value
    this.win = globalThis.extensionWin
    if (this.reqPerms == undefined || this.accessTokenId == undefined || this.reqPerms.length == 0) {
      Log.info("invalid parameters")
      this.initStatus = Constants.INIT_NEED_TO_TERMINATED
      return
    }
    Log.info("request permission=" + JSON.stringify(this.reqPerms) + ", tokenId = " + this.accessTokenId)
    Log.info("permission state=" + JSON.stringify(globalThis.abilityWant.parameters['ohos.user.grant.permission.state']));
    this.result = new Array(this.reqPerms.length).fill(-1);
    this.getStrings()
    let uid = globalThis.abilityWant.parameters['ohos.aafwk.param.callerUid']
    bundle.getNameForUid(uid).then((data) => {
      bundle.getBundleInfo(data, Constants.PARMETER_BUNDLE_FLAG).then(bundleInfo => {
        this.bundleInfo = bundleInfo
        this.getgrantGroups(globalThis.abilityWant.parameters['ohos.user.grant.permission.state']);
        this.getApplicationName(data, uid)
      })
    }).catch(err => {
      Log.error("getNameForUid error :" + JSON.stringify(err))
      this.initStatus = Constants.INIT_NEED_TO_TERMINATED
    })
  }
}

