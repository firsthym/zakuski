# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Node.delete_all
Node.create(title: '新闻', description: '军事 评论 图片')
Node.create(title: '体育', description: 'NBA 中超 英超')
Node.create(title: '娱乐', description: '电影 电视 音乐')
Node.create(title: '视频', description: '资讯 综艺 记录')
Node.create(title: '财经', description: '股票 基金 商业')
Node.create(title: '女人', description: '时尚 美容 情感')
Node.create(title: '科技', description: '概念 创造')
Node.create(title: '数码', description: '电器 电子')
Node.create(title: '手机', description: '移动 智能')
Node.create(title: '汽车', description: 'F1 购车')
Node.create(title: '旅游', description: '文化 自由 小站')
Node.create(title: '房产', description: '家居 装饰 交易')
Node.create(title: '游戏', description: '试玩 攻略')
Node.create(title: '生活', description: '亲子 教育 分享')