class Fork < ActiveRecord::Base
  belongs_to :project
  # 1002-se-team-gitlab changed #
  #attr_accessible :user_id
  attr_accessible :user_id, :project_id
  validates_presence_of :user_id, :project_id
  ###############################
end
