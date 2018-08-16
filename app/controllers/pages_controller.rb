class PagesController < ApplicationController
  def index; end

  def health
    respond_to do |format|
      format.json { render json: { status: 'OK' } }
    end
  end
end
