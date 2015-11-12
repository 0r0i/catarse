class FlexibleProject < ActiveRecord::Base
  include Project::BaseValidator

  belongs_to :project

  # ensure that we have only one flexible project per project
  validates :project_id, presence: true, uniqueness: true
  validates_length_of :name, maximum: Project::NAME_MAXLENGTH

  # delegate reusable methods from project
  delegate :expired?, :reached_goal?, :in_time_to_wait?,
    :notify_owner, :notify, :user, :payments,
    :headline, :about_html, :budget, :uploaded_image,
    :account, :video_thumbnail, :name, to: :project

  # delegate reusable methods from project
  delegate :expired?, :reached_goal?, :in_time_to_wait?,
    :notify_owner, :notify, :user, :payments,
    :headline, :about_html, :budget, :uploaded_image,
    :account, :video_thumbnail, :name, to: :project

  # instace of a flexible project state machine
  def state_machine
    @state_machine ||= FlexProjectMachine.new(self, {
      transition_class: FlexibleProjectTransition,
      association_name: :transitions
    })
  end
end
