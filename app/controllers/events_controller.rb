class EventsController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  def index
    @events = current_user.events
    respond_to do |format|
      format.html # HTMLリクエストの場合はビューを表示
      format.json { render json: @events } # JSONリクエストの場合はJSONを返す
    end
  end
  
  def show
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = current_user.events.build(event_params)
    
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, success: '予定を作成しました' }
        format.json { render json: @event, status: :created }
      else
        format.html { 
          flash.now[:danger] = '予定の作成に失敗しました'
          render :new, status: :unprocessable_entity
        }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, success: '予定を更新しました' }
        format.json { render json: @event }
      else
        format.html { 
          flash.now[:danger] = '予定の更新に失敗しました'
          render :edit, status: :unprocessable_entity
        }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @event.destroy
    
    respond_to do |format|
      format.html { redirect_to events_path, notice: '予定を削除しました' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_event
    @event = current_user.events.find(params[:id])
  end
  
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time)
  end
end