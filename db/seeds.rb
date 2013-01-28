# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Node.delete_all
Node.create(title: '兴趣', description: '游戏 电影 音乐 汽车 创意 艺术 旅行 文化', weight: 3)
Node.create(title: '职业', description: '科技 金融 教育 媒体 服务 建筑 人力', weight: 2)
Node.create(title: '综合', description: '视频 购物 好玩 生活 分享 城市 交易 工作 问答', weight: 1)

Tag.delete_all
Tag.create(name: '游戏')
Tag.create(name: '电影')
Tag.create(name: '音乐')
Tag.create(name: '汽车')
Tag.create(name: '创意')
Tag.create(name: '艺术')
Tag.create(name: '旅行')
Tag.create(name: '文化')
Tag.create(name: '科技')
Tag.create(name: '金融')
Tag.create(name: '教育')
Tag.create(name: '媒体')
Tag.create(name: '服务')
Tag.create(name: '建筑')
Tag.create(name: '人力')
Tag.create(name: '视频')
Tag.create(name: '购物')
Tag.create(name: '好玩')
Tag.create(name: '生活')
Tag.create(name: '分享')
Tag.create(name: '城市')
Tag.create(name: '交易')
Tag.create(name: '工作')
Tag.create(name: '问答')
Tag.create(name: '其他')