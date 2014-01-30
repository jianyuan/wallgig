require 'spec_helper'

describe "groups/index" do
  before(:each) do
    assign(:groups, [
      stub_model(Group,
        :owner => nil,
        :name => "Name",
        :slug => "Slug",
        :description => "MyText",
        :public => false,
        :admin_title => "Admin Title",
        :moderator_title => "Moderator Title",
        :member_title => "Member Title",
        :has_forums => false
      ),
      stub_model(Group,
        :owner => nil,
        :name => "Name",
        :slug => "Slug",
        :description => "MyText",
        :public => false,
        :admin_title => "Admin Title",
        :moderator_title => "Moderator Title",
        :member_title => "Member Title",
        :has_forums => false
      )
    ])
  end

  it "renders a list of groups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Admin Title".to_s, :count => 2
    assert_select "tr>td", :text => "Moderator Title".to_s, :count => 2
    assert_select "tr>td", :text => "Member Title".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
