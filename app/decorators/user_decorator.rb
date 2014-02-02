class UserDecorator < ApplicationDecorator
  def self.applicable_classes
    [User]
  end

  def role_title
    case role_level
    when 0
      "User"
    when 1
      "Admin"
    else
      raise InvalidUserRoleLevelError
    end
  end
end
