require 'spec_helper'

describe "categories/edit" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :name => "MyString",
      :slug => "MyString",
      :wikipedia_title => "MyString",
      :description => "MyText",
      :ancestry => "MyString"
    ))
  end

  it "renders the edit category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", category_path(@category), "post" do
      assert_select "input#category_name[name=?]", "category[name]"
      assert_select "input#category_slug[name=?]", "category[slug]"
      assert_select "input#category_wikipedia_title[name=?]", "category[wikipedia_title]"
      assert_select "textarea#category_description[name=?]", "category[description]"
      assert_select "input#category_ancestry[name=?]", "category[ancestry]"
    end
  end
end
