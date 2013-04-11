class Topic < Post
	field :image_url, type: String
	mount_uploader :thumbnail, ThumbnailUploader

	attr_accessible :image_url, :remote_thumbnail_url
end