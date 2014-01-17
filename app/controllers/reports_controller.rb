class ReportsController < ApplicationController
  before_action :set_reportable, only: [:new, :create]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/new
  def new
    @report = @reportable.reports.new
    @report.user = current_user
    authorize! :create, @report
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = @reportable.reports.new(report_params)
    @report.user = current_user
    authorize! :create, @report

    respond_to do |format|
      if @report.save
        format.html { redirect_to @reportable, notice: 'Report was successfully created.' }
        format.json { render action: 'show', status: :created, location: @reportable }
      else
        format.html { render action: 'new' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_reportable
      if params[:wallpaper_id].present?
        @reportable = Wallpaper.find(params[:wallpaper_id])
        authorize! :read, @reportable
      end
    end

    def report_params
      params.require(:report).permit(:description)
    end
end
