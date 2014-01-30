require 'spec_helper'

describe "forums/new" do
  before(:each) do
    assign(:forum, stub_model(Forum,
      :group => nil,
      :name => "MyString",
      :slug => "MyString",
      :description => "MyText",
      :position => 1
    ).as_new_record)
  end

  it "renders new forum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", forums_path, "post" do
      assert_select "input#forum_group[name=?]", "forum[group]"
      assert_select "input#forum_name[name=?]", "forum[name]"
      assert_select "input#forum_slug[name=?]", "forum[slug]"
      assert_select "textarea#forum_description[name=?]", "forum[description]"
      assert_select "input#forum_position[name=?]", "forum[position]"
    end
  end
end
