class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if(user && user.authenticate(params[:session][:password]))
		# sign in successfully
			sign_in user
			redirect_to user
		else
		# sign in with errors
			flash.now[:error] = 'Invalid email or password'
			render action: 'new'
		end
	end

	def destroy
		sign_out
		redirect_to signin_url
	end
	
end
