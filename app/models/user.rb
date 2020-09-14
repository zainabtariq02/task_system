# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  validates :name, presence: true
  before_destroy :can_destroy?, prepend: true
  after_create :send_welcome_reset_email

  attr_accessor :skip_password_validation, :email_send_status

  has_many :tasks_as_assignee, class_name: 'Task', foreign_key: 'assignee_user_id'
  has_many :tasks_as_reviewer, class_name: 'Task', foreign_key: 'reviewer_user_id'
  has_many :tasks_created, class_name: 'Task', foreign_key: 'created_by_user_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable

  def password_required?
    return false if skip_password_validation

    super
  end

  private
  
  def send_welcome_reset_email
    UserMailer.delay.welcome_reset_password_instructions(self)
  end

  def can_destroy?
    return true if tasks_as_assignee.empty? && tasks_as_reviewer.empty? && tasks_created.empty?
    
    errors.add(:base, 'User could not be destroyed!')
    throw :abort
    
  end
end
