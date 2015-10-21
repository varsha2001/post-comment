class User < ActiveRecord::Base
	  has_many :role
	    before_create :configure_permitted_parameters, if: :devise_controller?
	    #before_create :set_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 #private
  #def set_default_role
   # self.role ||= Role.find_by_name('employee')
  #end

end

def roles=(roles)
  self.role_id = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
end

def roles
  ROLES.reject do |r|
    ((role_id.to_i || 0) & 2**ROLES.index(r)).zero?
  end
end

def is?(role)
  roles.include?(role.to_s)
end
#can :manage, :all if user.is? :admin

ROLES = %w[employee admin ]
def role?(base_role)
  ROLES.index(base_role.to_s) <= ROLES.index(role)
end

private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, roles: [])}
  end
