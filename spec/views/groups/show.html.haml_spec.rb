require 'spec_helper'

describe "groups/show" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :owner => nil,
      :name => "Name",
      :slug => "Slug",
      :description => "MyText",
      :public => false,
      :admin_title => "Admin Title",
      :moderator_title => "Moderator Title",
      :member_title => "Member Title",
      :has_forums => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/Slug/)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(/Admin Title/)
    rendered.should match(/Moderator Title/)
    rendered.should match(/Member Title/)
    rendered.should match(/false/)
  end
end
