require 'spec_helper'

describe "groups/edit" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :owner => nil,
      :name => "MyString",
      :slug => "MyString",
      :description => "MyText",
      :public => false,
      :admin_title => "MyString",
      :moderator_title => "MyString",
      :member_title => "MyString",
      :has_forums => false
    ))
  end

  it "renders the edit group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", group_path(@group), "post" do
      assert_select "input#group_owner[name=?]", "group[owner]"
      assert_select "input#group_name[name=?]", "group[name]"
      assert_select "input#group_slug[name=?]", "group[slug]"
      assert_select "textarea#group_description[name=?]", "group[description]"
      assert_select "input#group_public[name=?]", "group[public]"
      assert_select "input#group_admin_title[name=?]", "group[admin_title]"
      assert_select "input#group_moderator_title[name=?]", "group[moderator_title]"
      assert_select "input#group_member_title[name=?]", "group[member_title]"
      assert_select "input#group_has_forums[name=?]", "group[has_forums]"
    end
  end
end
