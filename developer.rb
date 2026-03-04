VALID_ROLES = %w[engineer lead manager].freeze

class Developer
  attr_reader :name, :email, :role

  def initialize(name, email, role)
    raise ArgumentError, "Name cannot be empty"                        if name.to_s.strip.empty?
    raise ArgumentError, "Email cannot be empty"                       if email.to_s.strip.empty?
    raise ArgumentError, "Invalid email format"                        unless email.to_s.include?("@")
    raise ArgumentError, "Role must be engineer, lead, or manager"     unless VALID_ROLES.include?(role)
    @name  = name
    @email = email
    @role  = role
  end
end
