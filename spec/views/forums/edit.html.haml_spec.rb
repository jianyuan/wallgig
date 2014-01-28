require 'spec_helper'

describe "forums/edit" do
  before(:each) do
    @forum = assign(:forum, stub_model(Forum,
      :group => nil,
      :name => "MyString",
      :slug => "MyString",
      :description => "MyText",
      :position => 1
    ))
  end

  it "renders the edit forum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", forum_path(@forum), "post" do
      assert_select "input#forum_group[name=?]", "forum[group]"
      assert_select "input#forum_name[name=?]", "forum[name]"
      assert_select "input#forum_slug[name=?]", "forum[slug]"
      assert_select "textarea#forum_description[name=?]", "forum[description]"
      assert_select "input#forum_position[name=?]", "forum[position]"
    end
  end
end
