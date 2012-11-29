# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Node.delete_all
Node.create(title: '兴趣', description: '游戏 电影 音乐 汽车 创意 艺术 旅行 文化')
Node.create(title: '职业', description: '科技 金融 教育 媒体 服务 建筑 人力')
Node.create(title: '信息', description: '视频 购物 好玩 分享 城市 交易 工作 问答')