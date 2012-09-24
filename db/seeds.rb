# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Node.delete_all
Node.create(title: '新闻')
Node.create(title: '体育')
Node.create(title: '娱乐')
Node.create(title: '视频')
Node.create(title: '财经')
Node.create(title: '女人')
Node.create(title: '科技')
Node.create(title: '数码')
Node.create(title: '手机')
Node.create(title: '汽车')
Node.create(title: '旅游')
Node.create(title: '房产')
Node.create(title: '游戏')
Node.create(title: '生活')