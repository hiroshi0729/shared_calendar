class FriendshipsController < ApplicationController
    before_action :require_login
    
    # 友達申請一覧
    def index
        @sent_requests = current_user.friendships.where(status: 'pending')
        @received_requests = current_user.inverse_friendships.where(status: 'pending')
        @friends = current_user.accepted_friends
        
        # 友達とその Friendship レコードの対応を作成
        @friend_friendships = {}
        current_user.friendships.where(status: 'accepted').each do |friendship|
          @friend_friendships[friendship.friend_id] = friendship
        end
        current_user.inverse_friendships.where(status: 'accepted').each do |friendship|
          @friend_friendships[friendship.user_id] = friendship
        end
      end
    
    # 友達申請を送る
    def create
      @friend = User.find(params[:user_id])
      current_user.send_friend_request(@friend)
      redirect_to friendships_path, notice: '友達申請を送信しました'
    rescue ActiveRecord::RecordInvalid
      redirect_to friendships_path, alert: '友達申請に失敗しました'
    end
    
    # 友達申請を承認
    def accept
      @friendship = current_user.inverse_friendships.find(params[:id])
      @friendship.update(status: 'accepted')
      redirect_to friendships_path, notice: '友達申請を承認しました'
    end
    
    # 友達申請を拒否
    def reject
      @friendship = current_user.inverse_friendships.find(params[:id])
      @friendship.update(status: 'rejected')
      redirect_to friendships_path, notice: '友達申請を拒否しました'
    end
    
    # 友達関係を削除
    def destroy
      @friendship = Friendship.find(params[:id])
      if @friendship.user == current_user || @friendship.friend == current_user
        @friendship.destroy
        redirect_to friendships_path, notice: '友達関係を解除しました'
      else
        redirect_to friendships_path, alert: '不正な操作です'
      end
    end
  end
