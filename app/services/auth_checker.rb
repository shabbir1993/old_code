class AuthChecker

  VALID_IPS = ["66.226.220.106",   #PI Dallas
                "120.33.232.194",   #PE Fujian
                "127.0.0.1"]        #localhost

  def initialize(user, remote_ip)
    @user = user
    @remote_ip = remote_ip
  end

  def grant_access?
    @user && (valid_ip? || @user.is_admin?)
  end

  private

  def valid_ip?
    VALID_IPS.include?(@remote_ip)
  end
end
