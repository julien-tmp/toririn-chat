class Api::RoomsController < Api::V2::ApiController

  before_action :authenticate_user!
  before_action :set_rooms, only: %i(index)
  before_action :set_room, only: %i(show update destroy)

  def index
    render json: @rooms.sort{ |room| room.created_at }
  end

  def show
    render json: @room
  end

  def rqcode
    @code = RQRCode::QRCode.new("http://github.com/").as_png
    # binding.pry
    # p @code
    send_data(@code.to_s, disposition: 'inline', type: 'image/png')
  end

  def create
    @room = Room.new(room_params)
    @room.users << current_user
    if @room.save
      render json: @room, status: :created, location: api_v2_room_url(@room)
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
  end

  private

    def set_rooms
      @rooms = current_user.rooms.includes(:authorizations)
    end

    def set_room
      @room = current_user.rooms.where(id:params[:id]).first
    end

    def room_params
      params.require(:room).permit(:id, :title)
    end

end