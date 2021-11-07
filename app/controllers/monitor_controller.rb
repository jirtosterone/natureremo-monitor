class MonitorController < ApplicationController
  def index
    @devices = Device.all
  end
end
