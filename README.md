# ROS2開発用VNCデスクトップ環境
Webtopを使用したROS2開発環境

## 環境
- ベースイメージ: `linuxserver/webtop:ubuntu-mate`
- OS: `Ubuntu mate 24.04.2 LTS`
- ROS2 Distribution: `jazzy`

### コンテナ設定
- ユーザー名: ros2
- パスワード: password
- ポート: 3000, 3001 (Web), 3022 (SSH)
- 共有メモリ: 1GB

### システム設定
- ユーザー名: abc
- パスワード: abc

## コンテナの起動
`docker-compose up`

## 起動後の操作
```bash
source /opt/ros/jazzy/setup.bash
rosdep update
```
