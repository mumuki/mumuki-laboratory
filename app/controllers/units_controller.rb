require 'addressable/uri'

class UnitsController < ApplicationController
  def show
  end

  def subject
    @unit ||= Unit.find_by(id: params[:id])
  end
end
