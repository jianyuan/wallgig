class Forums
  include HTTParty
  base_uri ENV['FORUMS_API_URL']
  default_params api_key: ENV['FORUMS_API_KEY']

  def initialize(user)
    @user = user
  end

  def auth_token
    self.class.get("users/#{@user.id}/auth_token.json", { using_main_id: true })
  end

  def sign_up
    self.class.post("users.json", { query: user_options })
  end

  def refresh
    self.class.patch("users/#{@user.id}.json", { query: user_options })
  end

  private
    def user_options
      {
        user: {
          username: @user.username,
          name: @user.username,
          email: @user.email
        }
      }
    end
end