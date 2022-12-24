class StylesController < ApplicationController
  before_action :set_style, only: %i[show destroy]
  before_action :ensure_that_user_is_admin, only: %i[destroy]

  def index
    @styles = Style.all
  end

  def show
  end

  def destroy
    @style.destroy

    respond_to do |format|
      format.html { redirect_to styles_url, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_style
    @style = Style.find(params[:id])
  end
end
