/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

export const permissionGroups: any[] = [
    {
        "permissionName": "ohos.permission.LOCATION_IN_BACKGROUND",
        "groupName": "LOCATION",
        "label": "后台定位权限",
        "description": "允许应用在后台运行时获取位置信息。",
        "groupId": 0
    },
    {
        "permissionName": "ohos.permission.LOCATION",
        "groupName": "LOCATION",
        "label": "前台定位权限",
        "description": "允许应用在前台运行时获取位置信息。",
        "groupId": 0
    },
    {
        "permissionName": "ohos.permission.CAMERA",
        "groupName": "CAMERA",
        "label": "拍摄照片和录制视频",
        "description": "允许应用拍摄照片和视频。",
        "groupId": 1
    },
    {
        "permissionName": "ohos.permission.MICROPHONE",
        "groupName": "MICROPHONE",
        "label": "录制音频",
        "description": "允许应用打开或关闭录音通路。",
        "groupId": 2
    },
    {
        "permissionName": "ohos.permission.ANSWER_CALL",
        "groupName": "PHONE",
        "label": "接听电话",
        "description": "允许应用接听电话。",
        "groupId": 3
    },
    {
        "permissionName": "ohos.permission.MANAGE_VOICEMAIL",
        "groupName": "PHONE",
        "label": "语音信箱",
        "description": "允许应用管理语音信箱。",
        "groupId": 3
    },
    {
        "permissionName": "ohos.permission.READ_CELL_MESSAGES",
        "groupName": "SMS",
        "label": "读取小区广播",
        "description": "允许应用读取设备接收的小区广播信息。",
        "groupId": 4
    },
    {
        "permissionName": "ohos.permission.READ_MESSAGES",
        "groupName": "SMS",
        "label": "读取短彩信",
        "description": "允许应用读取设备接收的短彩信信息。",
        "groupId": 4
    },
    {
        "permissionName": "ohos.permission.RECEIVE_MMS",
        "groupName": "SMS",
        "label": "接收彩信",
        "description": "允许应用接收彩信。",
        "groupId": 4
    },
    {
        "permissionName": "ohos.permission.RECEIVE_SMS",
        "groupName": "SMS",
        "label": "接收短信",
        "description": "允许应用接收短信。",
        "groupId": 4
    },
    {
        "permissionName": "ohos.permission.RECEIVE_WAP_MESSAGES",
        "groupName": "SMS",
        "label": "接收WAP消息",
        "description": "允许应用接收和处理WAP消息。",
        "groupId": 4
    },
    {
        "permissionName": "ohos.permission.SEND_MESSAGES",
        "groupName": "SMS",
        "label": "发送短彩信",
        "description": "允许应用发送短彩信",
        "groupId": 4
    },
    {
        "permissionName": "ohos.permission.READ_CONTACTS",
        "groupName": "CONTACTS",
        "label": "读取通讯录",
        "description": "允许应用读取设备上存储的联系人信息。",
        "groupId": 5
    },
    {
        "permissionName": "ohos.permission.WRITE_CONTACTS",
        "groupName": "CONTACTS",
        "label": "新建/修改/删除通讯录",
        "description": "允许应用新建/修改/删除设备上存储的联系人信息。",
        "groupId": 5
    },
    {
        "permissionName": "ohos.permission.READ_CALL_LOG",
        "groupName": "CALL_LOG",
        "label": "读取通话记录",
        "description": "允许应用读取设备上的通话记录信息。",
        "groupId": 6
    },
    {
        "permissionName": "ohos.permission.WRITE_CALL_LOG",
        "groupName": "CALL_LOG",
        "label": "新建/修改/删除通话记录",
        "description": "允许新建/修改/删除设备上的通话记录信息。",
        "groupId": 6
    },
    {
        "permissionName": "ohos.permission.MEDIA_LOCATION",
        "groupName": "MEDIA",
        "label": "允许应用访问拍摄位置",
        "description": "应用访问用户媒体文件中的拍摄位置信息如经纬度信息。",
        "groupId": 7
    },
    {
        "permissionName": "ohos.permission.READ_MEDIA",
        "groupName": "MEDIA",
        "label": "允许应用读取媒体文件",
        "description": "允许应用访问户媒体文件，如视频、音频、图片等。",
        "groupId": 7
    },
    {
        "permissionName": "ohos.permission.WRITE_MEDIA",
        "groupName": "MEDIA",
        "label": "允许应用读写媒体文件",
        "description": "允许应用读写户媒体文件，如视频、音频、图片等。",
        "groupId": 7
    },
    {
        "permissionName": "ohos.permission.READ_CALENDAR",
        "groupName": "CALENDAR",
        "label": "读取日历",
        "description": "允许应用读取日历。",
        "groupId": 8
    },
    {
        "permissionName": "ohos.permission.WRITE_CALENDAR",
        "groupName": "CALENDAR",
        "label": "新建/修改/删除日历",
        "description": "允许应用新建/修改/删除日历。",
        "groupId": 8
    },
    {
        "permissionName": "ohos.permission.ACTIVITY_MOTION",
        "groupName": "SPORT",
        "label": "读取用户的运动状态",
        "description": "允许应用程序读取用户的运动状态。",
        "groupId": 9
    },
    {
        "permissionName": "ohos.permission.READ_HEALTH_DATA",
        "groupName": "HEALTH",
        "label": "读取用户的健康数据",
        "description": "允许应用程序读取用户的健康数据。",
        "groupId": 10
    },
    {
        "permissionName": "ohos.permission.DISTRIBUTED_DATASYNC",
        "groupName": "OTHER",
        "icon": $r("app.media.ic_multi_device_vector"),
        "text": "使用多设备协同？",
        "label": "多设备协同",
        "description": "发现并访问其他设备。",
        "groupId": 11
    },
    {
        "permissionName": "ohos.permission.READ_IMAGEVIDEO",
        "groupName": "IMAGE_AND_VIDEOS",
        "label": $r('sys.string.ohos_desc_read_imagevideo'),
        "description": "允许应用读取用户公共目录的图片或视频文件。",
        "groupId": 12
    },
    {
        "permissionName": "ohos.permission.WRITE_IMAGEVIDEO",
        "groupName": "IMAGE_AND_VIDEOS",
        "label": $r('sys.string.ohos_desc_write_imagevideo'),
        "description": "允许应用修改用户公共目录的图片或视频文件。",
        "groupId": 12
    },
    {
        "permissionName": "ohos.permission.READ_AUDIO",
        "groupName": "AUDIOS",
        "label": $r('sys.string.ohos_desc_read_audio'),
        "description": "允许应用读取用户公共目录的音频文件。",
        "groupId": 13
    },
    {
        "permissionName": "ohos.permission.WRITE_AUDIO",
        "groupName": "AUDIOS",
        "label": $r('sys.string.ohos_desc_write_audio'),
        "description": "允许应用修改用户公共目录的音频文件。",
        "groupId": 13
    },
    {
        "permissionName": "ohos.permission.READ_DOCUMENT",
        "groupName": "DOCUMENTS",
        "label": $r('sys.string.ohos_desc_read_document'),
        "description": "允许应用读取用户公共目录的文档。",
        "groupId": 14
    },
    {
        "permissionName": "ohos.permission.WRITE_DOCUMENT",
        "groupName": "DOCUMENTS",
        "label": $r('sys.string.ohos_desc_write_document'),
        "description": "允许应用修改用户公共目录的文档。",
        "groupId": 14
    },
    {
        "permissionName": "ohos.permission.READ_WHOLE_CALENDAR",
        "groupName": "CALENDAR_ALL",
        "label": $r('sys.string.ohos_lab_read_whole_calendar'),
        "groupId": 15
    },
    {
        "permissionName": "ohos.permission.WRITE_WHOLE_CALENDAR",
        "groupName": "CALENDAR_ALL",
        "label": $r('sys.string.ohos_lab_write_whole_calendar'),
        "groupId": 15
    }
]

export const groups: any[] = [
    {
        "name": "LOCATION",
        "groupName": "位置信息",
        "icon": $r('app.media.ic_public_gps'),
        "description": "",
	      "label": "访问位置信息？",
        "permissions": [
            "ohos.permission.LOCATION_IN_BACKGROUND",
            "ohos.permission.LOCATION"
        ],
        "isShow":true
    },
    {
        "name": "CAMERA",
        "groupName": "相机",
        "icon": $r('app.media.ic_public_camera'),
	      "label": "使用相机？",
        "description": "",
        "permissions": [
            "ohos.permission.CAMERA"
        ],
        "isShow":true
    },
    {
        "name": "MICROPHONE",
        "groupName": "麦克风",
        "icon": $r('app.media.ic_public_voice'),
	      "label": "使用麦克风？",
        "description": "",
        "permissions": [
            "ohos.permission.MICROPHONE"
        ],
        "isShow":true
    },
    {
        "name": "PHONE",
        "groupName": "电话",
        "icon": $r('app.media.ic_public_phone'),
	      "label": "使用拨打电话？",
        "description": "",
        "permissions": [
            "ohos.permission.ANSWER_CALL",
            "ohos.permission.MANAGE_VOICEMAIL"
        ],
        "isShow":false
    },
    {
        "name": "SMS",
        "groupName": "信息",
        "icon": $r('app.media.ic_public_message'),
        "label": "访问信息？",
	      "description": "",
        "permissions": [
            "ohos.permission.READ_CELL_MESSAGES",
            "ohos.permission.READ_MESSAGES",
            "ohos.permission.RECEIVE_MMS",
            "ohos.permission.RECEIVE_SMS",
            "ohos.permission.RECEIVE_WAP_MESSAGES",
            "ohos.permission.SEND_MESSAGES"
        ],
        "isShow":false
    },
    {
        "name": "CONTACTS",
        "groupName": "通讯录",
        "icon": $r('app.media.ic_public_contacts_group'),
        "label": "访问通讯录？",
	      "description": "",
        "permissions": [
            "ohos.permission.READ_CONTACTS",
            "ohos.permission.WRITE_CONTACTS"
        ],
        "isShow":false
    },
    {
        "name": "CALL_LOG",
        "groupName": "通话记录",
        "icon": $r('app.media.ic_call_logs'),
	      "label": "访问通话记录？",
	      "description": "",
        "permissions": [
            "ohos.permission.READ_CALL_LOG",
            "ohos.permission.WRITE_CALL_LOG"
        ],
        "isShow":false
    },
    {
        "name": "MEDIA",
        "groupName": "媒体和文件",
        "icon": $r('app.media.ic_public_folder'),
        "description": "",
	      "label": "访问媒体和文件？",
        "permissions": [
            "ohos.permission.MEDIA_LOCATION",
            "ohos.permission.READ_MEDIA",
            "ohos.permission.WRITE_MEDIA"
        ],
        "isShow":true
    },
    {
        "name": "CALENDAR",
        "groupName": "日历",
        "icon": $r('app.media.ic_public_calendar'),
        "label": "访问日历？",
	      "description": "",
        "permissions": [
            "ohos.permission.READ_CALENDAR",
            "ohos.permission.WRITE_CALENDAR"
        ],
        "isShow":true
    },
    {
        "name": "SPORT",
        "groupName": "健身运动",
        "icon": $r('app.media.ic_sport'),
	      "label": "访问健身运动？",
        "description": "",
        "permissions": [
            "ohos.permission.ACTIVITY_MOTION"
        ],
        "isShow":true
    },
    {
        "name": "HEALTH",
        "groupName": "身体传感器",
        "icon": $r('app.media.ic_ssensor'),
	      "label": "使用身体传感器？",
        "description": "",
        "permissions": [
            "ohos.permission.READ_HEALTH_DATA"
        ],
        "isShow":true
    },
    {
        "name": "OTHER",
        "groupName": "其他权限",
        "icon": $r('app.media.ic_more'),
        "description": "",
        "permissions": [
            "ohos.permission.DISTRIBUTED_DATASYNC"
        ],
        "isShow":false
    },
    {
        "name": "IMAGE_AND_VIDEOS",
        "groupName": $r('sys.string.ohos_lab_read_imagevideo'),
        "icon": $r('app.media.ic_public_folder'),
        "label": "访问图片和视频？",
        "description": "",
        "permissions": [
            "ohos.permission.READ_IMAGEVIDEO",
            "ohos.permission.WRITE_IMAGEVIDEO"
        ],
        "isShow":false
    },
    {
        "name": "AUDIOS",
        "groupName": $r('sys.string.ohos_lab_read_audio'),
        "icon": $r('app.media.ic_public_folder'),
        "label": "访问音乐和音频？",
        "description": "",
        "permissions": [
            "ohos.permission.READ_AUDIO",
            "ohos.permission.WRITE_AUDIO"
        ],
        "isShow":false
    },
    {
        "name": "DOCUMENTS",
        "groupName": $r('sys.string.ohos_lab_read_document'),
        "icon": $r('app.media.ic_public_folder'),
        "label": "访问文件？",
        "description": "",
        "permissions": [
            "ohos.permission.READ_DOCUMENT",
            "ohos.permission.WRITE_DOCUMENT"
        ],
        "isShow":false
    },
    {
        "name": "CALENDAR_ALL",
        "groupName": '全部日历',
        "icon": $r('app.media.ic_public_calendar'),
        "label": "访问全部日历？",
        "description": "",
        "permissions": [
            "ohos.permission.READ_WHOLE_CALENDAR",
            "ohos.permission.WRITE_WHOLE_CALENDAR"
        ],
        "isShow":false
    }
];

export const permissionGroupPermissions: object = {
    "LOCATION": [
        "ohos.permission.LOCATION_IN_BACKGROUND",
        "ohos.permission.LOCATION"
    ],
    "CAMERA": [
        "ohos.permission.CAMERA"
    ],
    "MICROPHONE": [
        "ohos.permission.MICROPHONE"
    ],
    "PHONE": [
        "ohos.permission.ANSWER_CALL",
        "ohos.permission.MANAGE_VOICEMAIL"
    ],
    "SMS": [
        "ohos.permission.READ_CELL_MESSAGES",
        "ohos.permission.READ_MESSAGES",
        "ohos.permission.RECEIVE_MMS",
        "ohos.permission.RECEIVE_SMS",
        "ohos.permission.RECEIVE_WAP_MESSAGES",
        "ohos.permission.SEND_MESSAGES"
    ],
    "CONTACTS": [
        "ohos.permission.READ_CONTACTS",
        "ohos.permission.WRITE_CONTACTS"
    ],
    "CALL_LOG": [
        "ohos.permission.READ_CALL_LOG",
        "ohos.permission.WRITE_CALL_LOG"
    ],
    "MEDIA": [
        "ohos.permission.MEDIA_LOCATION",
        "ohos.permission.READ_MEDIA",
        "ohos.permission.WRITE_MEDIA"
    ],
    "CALENDAR": [
        "ohos.permission.READ_CALENDAR",
        "ohos.permission.WRITE_CALENDAR"
    ],
    "SPORT": [
        "ohos.permission.ACTIVITY_MOTION"
    ],
    "HEALTH": [
        "ohos.permission.READ_HEALTH_DATA"
    ],
    "OTHER": [
        "ohos.permission.DISTRIBUTED_DATASYNC"
    ],
    "IMAGE_AND_VIDEOS": [
        "ohos.permission.READ_IMAGEVIDEO",
        "ohos.permission.WRITE_IMAGEVIDEO"
    ],
    "AUDIOS": [
        "ohos.permission.READ_AUDIO",
        "ohos.permission.WRITE_AUDIO"
    ],
    "DOCUMENTS": [
        "ohos.permission.READ_DOCUMENT",
        "ohos.permission.WRITE_DOCUMENT"
    ],
    "CALENDAR_ALL": [
        "ohos.permission.READ_WHOLE_CALENDAR",
        "ohos.permission.WRITE_WHOLE_CALENDAR"
    ]
};


export const userGrantPermissions: string[] = [
    "ohos.permission.LOCATION_IN_BACKGROUND",
    "ohos.permission.LOCATION",
    "ohos.permission.CAMERA",
    "ohos.permission.MICROPHONE",
    "ohos.permission.ANSWER_CALL",
    "ohos.permission.MANAGE_VOICEMAIL",
    "ohos.permission.READ_CELL_MESSAGES",
    "ohos.permission.READ_MESSAGES",
    "ohos.permission.RECEIVE_MMS",
    "ohos.permission.RECEIVE_SMS",
    "ohos.permission.RECEIVE_WAP_MESSAGES",
    "ohos.permission.SEND_MESSAGES",
    "ohos.permission.READ_CONTACTS",
    "ohos.permission.WRITE_CONTACTS",
    "ohos.permission.READ_CALL_LOG",
    "ohos.permission.WRITE_CALL_LOG",
    "ohos.permission.MEDIA_LOCATION",
    "ohos.permission.READ_MEDIA",
    "ohos.permission.WRITE_MEDIA",
    "ohos.permission.READ_CALENDAR",
    "ohos.permission.WRITE_CALENDAR",
    "ohos.permission.ACTIVITY_MOTION",
    "ohos.permission.READ_HEALTH_DATA",
    "ohos.permission.DISTRIBUTED_DATASYNC",
    "ohos.permission.READ_IMAGEVIDEO",
    "ohos.permission.WRITE_IMAGEVIDEO",
    "ohos.permission.READ_AUDIO",
    "ohos.permission.WRITE_AUDIO",
    "ohos.permission.READ_DOCUMENT",
    "ohos.permission.WRITE_DOCUMENT",
    "ohos.permission.READ_WHOLE_CALENDAR",
    "ohos.permission.WRITE_WHOLE_CALENDAR"
];

export const permissionGroupIds: object = {
    "ohos.permission.LOCATION_IN_BACKGROUND": "0",
    "ohos.permission.LOCATION": "0",
    "ohos.permission.CAMERA": "1",
    "ohos.permission.MICROPHONE": "2",
    "ohos.permission.ANSWER_CALL": "3",
    "ohos.permission.MANAGE_VOICEMAIL": "3",
    "ohos.permission.READ_CELL_MESSAGES": "4",
    "ohos.permission.READ_MESSAGES": "4",
    "ohos.permission.RECEIVE_MMS": "4",
    "ohos.permission.RECEIVE_SMS": "4",
    "ohos.permission.RECEIVE_WAP_MESSAGES": "4",
    "ohos.permission.SEND_MESSAGES": "4",
    "ohos.permission.READ_CONTACTS": "5",
    "ohos.permission.WRITE_CONTACTS": "5",
    "ohos.permission.READ_CALL_LOG": "6",
    "ohos.permission.WRITE_CALL_LOG": "6",
    "ohos.permission.MEDIA_LOCATION": "7",
    "ohos.permission.READ_MEDIA": "7",
    "ohos.permission.WRITE_MEDIA": "7",
    "ohos.permission.READ_CALENDAR": "8",
    "ohos.permission.WRITE_CALENDAR": "8",
    "ohos.permission.ACTIVITY_MOTION": "9",
    "ohos.permission.READ_HEALTH_DATA": "10",
    "ohos.permission.DISTRIBUTED_DATASYNC": "11",
    "ohos.permission.READ_IMAGEVIDEO": "12",
    "ohos.permission.WRITE_IMAGEVIDEO": "12",
    "ohos.permission.READ_AUDIO": "13",
    "ohos.permission.WRITE_AUDIO": "13",
    "ohos.permission.READ_DOCUMENT": "14",
    "ohos.permission.WRITE_DOCUMENT": "14",
    "ohos.permission.READ_WHOLE_CALENDAR": "15",
    "ohos.permission.WRITE_WHOLE_CALENDAR": "15"
};

export const noNeedDisplayApp: string[] = [
    "com.ohos.launcher"
]

export const showSubpermissionsGrop: string[] = [
    "PHONE",
    "CALENDAR",
    "SMS",
    "CONTACTS",
    "CALL_LOG"
];

export const polymorphismGroup: string[] = [
    "LOCATION"
]