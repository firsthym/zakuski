class Topic < Post
	mount_uploader :thumbnail, ThumbnailUploader
end