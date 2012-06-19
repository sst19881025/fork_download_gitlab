class Admin::ProjectsController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!
  before_filter :authenticate_admin!

  def index
    @admin_projects = Project.page(params[:page])
  end

  def show
    @admin_project = Project.find_by_code(params[:id])

    @users = if @admin_project.users.empty?
               User
             else
               User.not_in_project(@admin_project)
             end.all
  end

  def new
    @admin_project = Project.new
  end

  def edit
    @admin_project = Project.find_by_code(params[:id])
	p "pppppppppppppppppppppppppppppppppppppppppppp"
  end

  def team_update
    @admin_project = Project.find_by_code(params[:id])

    UsersProject.bulk_import(
      @admin_project, 
      params[:user_ids],
      params[:project_access]
    )

    @admin_project.update_repository

    redirect_to [:admin, @admin_project], notice: 'Project was successfully updated.'
  end

  def create
    @admin_project = Project.new(params[:project])
    @admin_project.owner = current_user

    if @admin_project.save
      redirect_to [:admin, @admin_project], notice: 'Project was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @admin_project = Project.find_by_code(params[:id])

    owner_id = params[:project].delete(:owner_id)

    if owner_id 
      @admin_project.owner = User.find(owner_id)
    end

    if @admin_project.update_attributes(params[:project])
      redirect_to [:admin, @admin_project], notice: 'Project was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @admin_project = Project.find_by_code(params[:id])
    @admin_project.destroy

    redirect_to admin_projects_url
  end

#=begin
  ### Inplementation of Download 

  def archive

 #   unless can?(current_user, :download_code, @project)
  #    render_404 and return
   # end

	@project = Project.find_by_code(params[:id])
 
	ref = params[:ref] || @project.root_ref
	commit = @project.commit(ref)
	render_404 and return unless commit
	p ref


    # Build file path
	file_name = @project.code + "-" + commit.id.to_s + ".tar.gz"
	storage_path = File.join(Rails.root, "tmp", "repositories", @project.code)
	file_path = File.join(storage_path, file_name)
	p file_name 
	p storage_path
	p file_path

	# Create file if not exists
	unless File.exists?(file_path)
		p "wwwwwwwwwwwwwwwwwwww"
		p "wwwwwwwwwwwwwwwwwwww"
		p "wwwwwwwwwwwwwwwwwwww"

		FileUtils.mkdir_p storage_path
		file = @project.repo.archive_to_file("wwwwwwwwwww", nil,  file_path)
	end

	# Send file to user
	#p "wwwwwwwwwwwwwwwwwwww"
	send_file file_path
	#redirect_to admin_projects_url	
  end
#=end
end
