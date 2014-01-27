class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin? || user.moderator?
      can :manage, :all
    else
      # Collection
      can :read, Collection, public: true

      # Favourite
      can :read, Favourite, wallpaper: { processing: false, purity: 'sfw' }

      # User
      can :read, User

      if user.persisted?
        # Wallpaper
        can :crud, Wallpaper, user_id: user.id
        can :read, Wallpaper, processing: false
        can [:update, :update_purity], Wallpaper
        cannot :update_purity, Wallpaper, purity_locked: true

        # Favourite
        can :crud, Favourite, user_id: user.id

        # Collection
        can :crud, Collection, user_id: user.id

        # Comment
        can :crud, Comment, user_id: user.id
        cannot :destroy, Comment do |comment|
          # 15 minutes to destroy a comment
          Time.now - comment.created_at > 15.minutes
        end

        # User
        can :crud, User, id: user.id
      else
        # Wallpaper
        can :read, Wallpaper, processing: false, purity: 'sfw'
      end
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end