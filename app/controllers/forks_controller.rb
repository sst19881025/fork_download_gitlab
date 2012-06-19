
class ForksController < ApplicationController
    respond_to :html,:js,:xml

	def new
		@fork = Fork.new
	end

    def create
		@fork = Fork.new(params[:fork]) # model name?
		@fork.save
		#@sst = Fork.where( :project_id => @fork.project_id, :user_id => @fork.user_id ).last

		@user = User.find(@fork.user_id)
		@prj = Project.find(@fork.project_id)

=begin
		@project = Project.new(@prj)
    	@project.owner = @user

		Project.transaction do
		  @project.save!
		  @project.users_projects.create!(:project_access => UsersProject::MASTER, :user => current_user)

		  # when project saved no team member exist so 
		  # project repository should be updated after first user add
		  @project.update_repository
		end
=end
		#@comment = @post.comments.create(params[:comment])

		#redirect_to prj_fork_url(@project)
    end
end
