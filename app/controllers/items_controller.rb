class ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token # allow CSRF

  def new
  end

  def create
    Item.new.insert(
      :name              => params[:name],
      :content_type      => params[:file].content_type,
      :original_filename => params[:file].original_filename,
      :file_data => BSON::Binary.new(params[:file].read, BSON::Binary::SUBTYPE_BYTES)
    )
    render :json => {:result => :success}
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
    @items = Item.new.find
  end

  def show
  end

  def image
    item = Item.new.find_by_id(params[:id])
    send_data(item["file_data"].to_s, :filename => item["name"], :content_type => item["content_type"], :disposition => "inline")
  end

  private

end
