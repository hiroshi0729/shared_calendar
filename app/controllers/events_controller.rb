class EventsController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  def index
    # 基本は自分のイベントを取得
    @events = current_user.events
    
    # 友達のIDが指定されている場合は友達のイベントも追加
    if params[:friend_ids].present?
      friend_ids = params[:friend_ids].reject(&:blank?).map(&:to_i)
      if friend_ids.any?
        friend_events = Event.where(user_id: friend_ids)
        @events = @events.or(friend_events)
      end
    end
    
    respond_to do |format|
      format.html do
        # HTML表示用に友達一覧を取得
        @friends = current_user.accepted_friends
      end
      format.json do
        render json: @events.map { |event|
          {
            id: event.id,
            title: event.title,
            start_time: event.start_time,
            end_time: event.end_time,
            user_id: event.user_id  # カレンダーで色分けするために必要
          }
        }
      end
    end
  end
  
  def show
    # ゲスト一覧を取得
    @guests = @event.guests
  end
  
  def new
    @event = Event.new
    
    # URLパラメータから日時を取得(カレンダーから遷移した場合)
    if params[:start_time].present?
      @event.start_time = params[:start_time]
    end
    
    if params[:end_time].present?
      @event.end_time = params[:end_time]
    end
    
    @friends = current_user.accepted_friends
  end
  
  def create
    @event = current_user.events.build(event_params)
    
    respond_to do |format|
      if @event.save
        # ゲストを追加
        if params[:event][:guest_ids].present?
          guest_ids = params[:event][:guest_ids].reject(&:blank?)
          guest_ids.each do |guest_id|
            @event.event_guests.create(user_id: guest_id)
          end
        end
        
        format.html { redirect_to events_path, success: '予定を作成しました' }
        format.json { render json: @event, status: :created }
      else
        @friends = current_user.accepted_friends
        format.html { 
          flash.now[:danger] = '予定の作成に失敗しました'
          render :new, status: :unprocessable_entity
        }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @friends = current_user.accepted_friends
  end
  
  def update
    respond_to do |format|
      if @event.update(event_params)
        # ゲストを更新
        @event.event_guests.destroy_all
        if params[:event][:guest_ids].present?
          guest_ids = params[:event][:guest_ids].reject(&:blank?)
          guest_ids.each do |guest_id|
            @event.event_guests.create(user_id: guest_id)
          end
        end
        
        format.html { redirect_to events_path, success: '予定を更新しました' }
        format.json { render json: @event }
      else
        @friends = current_user.accepted_friends
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
    # 自分のイベント または ゲストとして招待されているイベントを取得
    @event = Event.find(params[:id])
    
    # 自分のイベントでもなく、ゲストでもない場合はエラー
    unless @event.user_id == current_user.id || @event.guests.include?(current_user)
      redirect_to events_path, danger: 'アクセス権限がありません'
    end
  end
  
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :location)
  end
end