require 'spec_helper'

describe "reports/new" do
  before(:each) do
    assign(:report, stub_model(Report,
      :reportable => nil,
      :user => nil,
      :description => "MyText",
      :closed_by => nil
    ).as_new_record)
  end

  it "renders new report form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", reports_path, "post" do
      assert_select "input#report_reportable[name=?]", "report[reportable]"
      assert_select "input#report_user[name=?]", "report[user]"
      assert_select "textarea#report_description[name=?]", "report[description]"
      assert_select "input#report_closed_by[name=?]", "report[closed_by]"
    end
  end
end
