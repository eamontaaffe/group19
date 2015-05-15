class PredictionsController < ApplicationController
  def get_prediction_by_postcode
    params[:post_code]
    params[:period]
    @out = {}
    respond_to do |format|
      format.html
      format.json { render json: JSON.pretty_generate(@out.as_json) }
    end
  end
end
