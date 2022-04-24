class ApplicationController < ActionController::Base
  before_action :repo_info, only: [:index, :show, :edit, :new]

  def repo_info
    @holiday_facade = HolidayFacade.new
  end
end
