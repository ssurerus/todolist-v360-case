class ModalsController < ApplicationController
  def close
    respond_to do |format|
      format.turbo_stream
    end
  end
end
