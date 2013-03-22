# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
node_interest = Node.find_by(title: '兴趣') || Node.create(title_translations: { "zh-CN" => '兴趣', "en" => 'Interests'},
			description_translations: {"zh-CN" => '发现你8小时以外的人生。', "en" => ""}, 
			weight: 3, keyname: "interests")
node_job = Node.find_by(title: '职业') || Node.create(title_translations: { "zh-CN" => '职业', "en" => 'Jobs'},
			description_translations: {"zh-CN" => '找到工作之所需，答案抑或朋友。', "en" => ""},
			weight: 2, keyname: "jobs")
node_share = Node.find_by(title: '分享') || Node.create(title_translations: { "zh-CN" => '分享', "en" => 'Share'}, 
			description_translations: {"zh-CN" => '分享你的发现，无论文艺，怪咖，还是其他。', "en" => ""},
			weight: 1, keyname: "share")

Tag.new(name_translations: {"zh-CN" => '游戏', "en" => "Games" }, node_id: node_interest.id, keyname: "games").save unless Tag.where(name: '游戏').exists?
Tag.new(name_translations: {"zh-CN" => '电影', "en" => "Movies" }, node_id: node_interest.id, keyname: "movies" ).save unless Tag.where(name: '电影').exists?
Tag.new(name_translations: {"zh-CN" => '音乐', "en" => "Music" }, node_id: node_interest.id, keyname: "music").save unless Tag.where(name: '音乐').exists?
Tag.new(name_translations: {"zh-CN" => '汽车', "en" => "Cars" }, node_id: node_interest.id, keyname: "cars").save unless Tag.where(name: '汽车').exists?
Tag.new(name_translations: {"zh-CN" => '创意', "en" => "Creatives" }, node_id: node_interest.id, keyname: "creatives").save unless Tag.where(name: '创意').exists?
Tag.new(name_translations: {"zh-CN" => '艺术', "en" => "Arts" }, node_id: node_interest.id, keyname: "arts").save unless Tag.where(name: '艺术').exists?
Tag.new(name_translations: {"zh-CN" => '旅行', "en" => "Travel" }, node_id: node_interest.id, keyname: "travel").save unless Tag.where(name: '旅行').exists?
Tag.new(name_translations: {"zh-CN" => '文化', "en" => "Culture" }, node_id: node_interest.id, keyname: "culture").save unless Tag.where(name: '文化').exists?
Tag.new(name_translations: {"zh-CN" => '科技', "en" => "Technology" }, node_id: node_job.id, keyname: "technology").save unless Tag.where(name: '科技').exists?
Tag.new(name_translations: {"zh-CN" => '金融', "en" => "Finace" }, node_id: node_job.id, keyname: "finace").save unless Tag.where(name: '金融').exists?
Tag.new(name_translations: {"zh-CN" => '教育', "en" => "Education" }, node_id: node_job.id, keyname: "education").save unless Tag.where(name: '教育').exists?
Tag.new(name_translations: {"zh-CN" => '媒体', "en" => "Media" }, node_id: node_job.id, keyname: "media").save unless Tag.where(name: '媒体').exists?
Tag.new(name_translations: {"zh-CN" => '服务', "en" => "Service" }, node_id: node_job.id, keyname: "service").save unless Tag.where(name: '服务').exists?
Tag.new(name_translations: {"zh-CN" => '建筑', "en" => "Architecture" }, node_id: node_job.id, keyname: "architecture").save unless Tag.where(name: '建筑').exists?
Tag.new(name_translations: {"zh-CN" => '人力', "en" => "Human Resource" }, node_id: node_job.id, keyname: "hr").save unless Tag.where(name: '人力').exists?
Tag.new(name_translations: {"zh-CN" => '程序员', "en" => "Programmer" }, node_id: node_job.id, keyname: "programmer").save unless Tag.where(name: '程序员').exists?
Tag.new(name_translations: {"zh-CN" => '会计师', "en" => "Accountant" }, node_id: node_job.id, keyname: "accountant").save unless Tag.where(name: '会计师').exists?
Tag.new(name_translations: {"zh-CN" => '视频', "en" => "Video" }, node_id: node_share.id, keyname: "video").save unless Tag.where(name: '视频').exists?
Tag.new(name_translations: {"zh-CN" => '购物', "en" => "Shopping" }, node_id: node_share.id, keyname: "shopping").save unless Tag.where(name: '购物').exists?
Tag.new(name_translations: {"zh-CN" => '好玩', "en" => "Fun" }, node_id: node_share.id, keyname: "fun").save unless Tag.where(name: '好玩').exists?
Tag.new(name_translations: {"zh-CN" => '生活', "en" => "Life" }, node_id: node_share.id, keyname: "life").save unless Tag.where(name: '生活').exists?
Tag.new(name_translations: {"zh-CN" => '城市', "en" => "City" }, node_id: node_share.id, keyname: "city").save unless Tag.where(name: '城市').exists?
Tag.new(name_translations: {"zh-CN" => '交易', "en" => "Trade" }, node_id: node_share.id, keyname: "trade").save unless Tag.where(name: '交易').exists?
Tag.new(name_translations: {"zh-CN" => '工作', "en" => "Work" }, node_id: node_share.id, keyname: "work").save unless Tag.where(name: '工作').exists?
Tag.new(name_translations: {"zh-CN" => '问答', "en" => "Q&A" }, node_id: node_share.id, keyname: "qa").save unless Tag.where(name: '问答').exists?
Tag.new(name_translations: {"zh-CN" => '医疗', "en" => "Medical" }, node_id: node_share.id, keyname: "medical").save unless Tag.where(name: '医疗').exists?
