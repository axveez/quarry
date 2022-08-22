class MainController < ApplicationController
  before_action :authenticate_user!
  def index
    @assets = Asset.all
    @driver = Driver.all
    @fleets = Fleet.where("time_in is null")
    @quarries = Quarry.where("time_out is null")
    @backfills = Backfill.where("time_out is null")
    if params[:date].present?
      session[:date] = params[:date]
      redirect_to "/"
    end

    @logs = Log.where(:date=>session[:date]).order("id desc")
  end

  def todo
    @title = "To Do List"
    
  end
end
