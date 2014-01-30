require 'spec_helper'

describe "forums/show" do
  before(:each) do
    @forum = assign(:forum, stub_model(Forum,
      :group => nil,
      :name => "Name",
      :slug => "Slug",
      :description => "MyText",
      :position => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
    rendered.should match(/Slug/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
  end
end
