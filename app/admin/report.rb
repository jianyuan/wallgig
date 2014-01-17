ActiveAdmin.register Report do
  config.sort_order = 'created_at_asc'
  menu label: proc { "Reports (#{Report.open.count})" }
  actions :index, :show

  scope(:open, default: true) { |reports| reports.open }
  scope :closed

  index do
    column :id
    column 'Reportable' do |report|
      link_to report.reportable, report.reportable
    end
    column 'Reported by' do |report|
      link_to report.user.username, report.user if report.user.present?
    end
    column :description, sortable: false
    if current_scope.id == 'closed'
      column :closed_by
      column :closed_at
    end
    column :created_at
    actions do |report|
      if report.closed?
        link_to 'Open', open_admin_report_path(report), class: 'member_link', data: { method: :patch, confirm: 'Are you sure?' }
      else
        link_to 'Close', close_admin_report_path(report), class: 'member_link', data: { method: :patch, confirm: 'Are you sure?' }
      end
    end
  end

  member_action :close, method: :patch do
    resource.close_by_user!(current_active_admin_user)
    redirect_to :back, notice: 'Report was successfully closed.'
  end

  member_action :open, method: :patch do
    resource.open!
    redirect_to :back, notice: 'Report was successfully reopened.'
  end

  controller do
    def scoped_collection
      resource_class.includes(:reportable, :user)
    end
  end
end
