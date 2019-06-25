import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mark/entity/backup_db.dart';
import 'package:mark/manager/db_manager.dart';
import 'package:mark/manager/file_manager.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:toast/toast.dart';

class SettingPage extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String versionName;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        this.versionName = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text.rich(TextSpan(
                text: '设置',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '  (v$versionName)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ])),
          ),
          SizedBox(
            height: 40.0,
          ),
          Container(
            height: 30.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: white_02,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '数据管理',
                  style: TextStyle(
                    color: text_hint,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            child: _buildItem('清理App数据(不包括备份数据)', first: true),
            onTap: () {
              this._showClearDialog(context);
            },
          ),
          InkWell(
            child: _buildItem('清理本地备份数据'),
            onTap: () {
              this._showClearDBDialog(context);
            },
          ),
          InkWell(
            child: _buildItem('备份数据到本地'),
            onTap: () {
              FileManager().backupDB().then((value) {
                if (value) {
                  Toast.show('备份数据成功', context);
                } else {
                  Toast.show('备份数据失败', context);
                }
              }).catchError((error) {
                Toast.show('备份数据失败', context);
              });
            },
          ),
          InkWell(
            child: _buildItem('从本地恢复数据'),
            onTap: () {
              this._showRestoreDialog(context);
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildItem(String name, {first = false}) {
    var widgets = List<Widget>();
    if (!first) {
      widgets.add(Container(
        decoration: BoxDecoration(color: bg_divide),
        child: SizedBox(
          width: double.infinity,
          height: 1.0,
        ),
      ));
    } else {
      widgets.add(SizedBox(
        height: 1.0,
      ));
    }
    widgets.add(SizedBox(
      width: double.infinity,
      child: Text(
        name,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14,
          color: text_black,
        ),
      ),
    ));
    widgets.add(SizedBox(
      height: 1.0,
    ));

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }

  void _showClearDBDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SimpleDialog(
            title: Text('删除所有备份的数据'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('确定'),
                onPressed: () {
                  FileManager().deleteBackup().then((value) {
                    Toast.show('删除成功', context);
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    Toast.show('删除失败', context);
                  });
                },
              )
            ],
          );
        });
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SimpleDialog(
            title: Text('删除所有历史记录,请确保您已经做好数据备份，否则数据无法恢复'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('确定'),
                onPressed: () {
                  FileManager().deleteDB().then((value) {
                    Toast.show('删除成功', context);
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    Toast.show('删除失败', context);
                  });
                },
              )
            ],
          );
        });
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          String selected = '';
          BackupDbFileEntity selectFileEntity;
          var filesA;
          int type = 0; // 0 loading, 1 data, 2 error, 3 data empty

          return AlertDialog(
            title: Text('选择要恢复的数据(非增量恢复，当前App数据会全部清除)'),
            actions: <Widget>[
              FlatButton(
                child: Text('确认'),
                onPressed: () {
                  if (selectFileEntity != null) {
                    //TODO 检查数据库版本号，版本号不符合就不能恢复
                    FileManager().restoreDB(selected).then((value) {
                      Toast.show('数据恢复成功', context);
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      Toast.show('数据恢复失败', context);
                    });
                  } else {
                    Toast.show('未选中要恢复的数据', context);
                  }
                },
              ),
            ],
            content: StatefulBuilder(
              builder: (context, StateSetter setState) {
                var widgets = List<Widget>();
                switch (type) {
                  case 0:
                    widgets.add(Text('数据正在加载中... $type'));
                    break;
                  case 1:
                    if (filesA == null) {
                      break;
                    }

                    for (BackupDbFileEntity file in filesA) {
                      widgets.add(CheckboxListTile(
                          title: Text("${file.file.path}"),
                          value: selected == file.name,
                          onChanged: (bool) {
                            setState(() {
                              selected = file.name;
                              selectFileEntity = file;
                            });
                          }));
                    }
                    break;
                  case 2:
                    widgets.add(Text('数据加载发生错误 $type'));
                    break;
                  default:
                    widgets.add(
                        Text('没有发现备份数据(Android 用户:备份数据请放在 mark_backup 文件夹下)'));
                    break;
                }

                if (type == 0) {
                  FileManager().getBackupFiles().then((files) {
                    Logger.d(msg: 'backup db file count: ${files.length}');
                    if (files.length == 0) {
                      setState(() {
                        type = 3;
                        filesA = null;
                      });
                    } else {
                      setState(() {
                        type = 1;
                        filesA = files;
                      });
                    }
                  }).catchError((error) {
                    setState(() {
                      filesA = null;
                      type = 2;
                    });
                  });
                }

                return SingleChildScrollView(
                  child: ListBody(
                    children: widgets,
                  ),
                );
              },
            ),
          );
        });
  }
}
