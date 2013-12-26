class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    clear_aliased_actions

    alias_action :index, :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :manage, :all
    end

    if user.moderator?
      can :crud, :all
    end

    # Collection
    can [:index, :read], Collection, public: true
    can :crud, Collection, user_id: user.id

    # Comment
    can :crud, Comment, user_id: user.id

    # Favourite
    can :crud, Favourite, user_id: user.id

    # Wallpaper
    if user.persisted?
      can :read, Wallpaper, processing: false
      can :index, Wallpaper, processing: false, id: user.favourite_wallpaper_ids
      can :update_purity, Wallpaper
      cannot :update_purity, Wallpaper, purity_locked: true
    end
    # Guests can view SFW wallpapers only
    can [:index, :read], Wallpaper, processing: false, purity: 'sfw'
    can :crud, Wallpaper, user_id: user.id

    # User
    can :read, User
    can :crud, User, id: user.id

    # Signed in users
    if user.persisted?
      # Wallpaper
      can :update, Wallpaper
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
