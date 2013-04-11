class ShadowWorker
	include Sidekiq::Worker

	def perform(topic_id)
		topic = Topic.find(topic_id)
		topic.remote_thumbnail_url = topic.image_url
		logger.debug "::::::::::::::::::::topic: #{topic.id}"

		r = topic.save
	end
end