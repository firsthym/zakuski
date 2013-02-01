# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
node_interest = Node.find_by(title: '兴趣') || Node.create(title: '兴趣', 
            description: '游戏 电影 音乐 汽车 创意 艺术 旅行 文化', weight: 3)
node_job = Node.find_by(title: '职业') || Node.create(title: '职业',
              description: '科技 金融 教育 媒体 服务 建筑 人力', weight: 2)
node_share = Node.find_by(title: '分享') || Node.create(title: '分享', 
            description: '视频 购物 好玩 生活 城市 交易 工作 问答', weight: 1)

Tag.new(name: '游戏', node_id: node_interest.id ).save unless Tag.where(name: '游戏').exists?
Tag.new(name: '电影', node_id: node_interest.id ).save unless Tag.where(name: '电影').exists?
Tag.new(name: '音乐', node_id: node_interest.id ).save unless Tag.where(name: '音乐').exists?
Tag.new(name: '汽车', node_id: node_interest.id ).save unless Tag.where(name: '汽车').exists?
Tag.new(name: '创意', node_id: node_interest.id ).save unless Tag.where(name: '创意').exists?
Tag.new(name: '艺术', node_id: node_interest.id ).save unless Tag.where(name: '艺术').exists?
Tag.new(name: '旅行', node_id: node_interest.id ).save unless Tag.where(name: '旅行').exists?
Tag.new(name: '文化', node_id: node_interest.id ).save unless Tag.where(name: '文化').exists?
Tag.new(name: '科技', node_id: node_job.id ).save unless Tag.where(name: '科技').exists?
Tag.new(name: '金融', node_id: node_job.id ).save unless Tag.where(name: '金融').exists?
Tag.new(name: '教育', node_id: node_job.id ).save unless Tag.where(name: '教育').exists?
Tag.new(name: '媒体', node_id: node_job.id ).save unless Tag.where(name: '媒体').exists?
Tag.new(name: '服务', node_id: node_job.id ).save unless Tag.where(name: '服务').exists?
Tag.new(name: '建筑', node_id: node_job.id ).save unless Tag.where(name: '建筑').exists?
Tag.new(name: '人力', node_id: node_job.id ).save unless Tag.where(name: '人力').exists?
Tag.new(name: '视频', node_id: node_share.id ).save unless Tag.where(name: '视频').exists?
Tag.new(name: '购物', node_id: node_share.id ).save unless Tag.where(name: '购物').exists?
Tag.new(name: '好玩', node_id: node_share.id ).save unless Tag.where(name: '好玩').exists?
Tag.new(name: '生活', node_id: node_share.id ).save unless Tag.where(name: '生活').exists?
Tag.new(name: '城市', node_id: node_share.id ).save unless Tag.where(name: '城市').exists?
Tag.new(name: '交易', node_id: node_share.id ).save unless Tag.where(name: '交易').exists?
Tag.new(name: '工作', node_id: node_share.id ).save unless Tag.where(name: '工作').exists?
Tag.new(name: '问答', node_id: node_share.id ).save unless Tag.where(name: '游戏').exists?
