require 'spec_helper'

describe QueueItemsController do
  describe "Get index" do
    it "sets @queue_items to the queue items of the logged in user" do
      billy = Fabricate(:user)
      set_current_user(billy)
      queue_item1 = Fabricate(:queue_item, user: billy)
      queue_item2 = Fabricate(:queue_item, user: billy)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end
  end
  describe "POST create" do
    it "redirects to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      QueueItem.delete_all
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      QueueItem.delete_all
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it "creates the queue item that is associated with the sign in user" do
      QueueItem.delete_all
      billy = Fabricate(:user)
      set_current_user(billy)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(billy)
    end
    it "puts the video as the last one in the queue" do
      QueueItem.delete_all
      billy = Fabricate(:user)
      set_current_user(billy)
      dumb   = Fabricate(:video)
      Fabricate(:queue_item, video: dumb, user: billy)
      bob = Fabricate(:video)
      post :create, video_id: bob.id
      bob_queue_item = QueueItem.where(video_id: bob.id, user_id: billy.id).first
      expect(bob_queue_item.position).to eq(2)
    end
    it "does not at the video the queue if the video is already in the queue" do
      QueueItem.delete_all
      billy = Fabricate(:user)
      set_current_user(billy)
      dumb   = Fabricate(:video)
      Fabricate(:queue_item, video: dumb, user: billy)
      post :create, video_id: dumb.id
      expect(billy.queue_items.count).to eq(1)
    end
    it_behaves_like "requires sign in" do
      let(:action) {post :create, video_id: 3}
    end
  end

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
      QueueItem.delete_all
      billy = Fabricate(:user)
      set_current_user(billy)
      queue_item = Fabricate(:queue_item, user: billy)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      QueueItem.delete_all
      billy = Fabricate(:user)
      set_current_user(billy)
      queue_item1 = Fabricate(:queue_item, user: billy, position: 1)
      queue_item2 = Fabricate(:queue_item, user: billy, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if the queue item is not in the current users queue" do
      QueueItem.delete_all
      billy = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(billy)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 3}
    end
  end

  describe "POST update queue" do
    context "with valid inputs" do
      it "redirects to the my queue page" do
        billy = Fabricate(:user)
        set_current_user(billy)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: billy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        billy = Fabricate(:user)
        set_current_user(billy)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: billy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(billy.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        billy = Fabricate(:user)
        set_current_user(billy)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: billy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(billy.queue_items.map(&:position)).to eq([1,2])
      end
    end

    context "with invalid inputs" do
      it "sets the flash error message" do
        billy = Fabricate(:user)
        set_current_user(billy)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: billy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "redirects to the my queue page" do
        billy = Fabricate(:user)
        set_current_user(billy)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: billy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end
      it "does not change the queue items" do
        billy = Fabricate(:user)
        set_current_user(billy)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: billy, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with unathenticated users" do
      it_behaves_like "requires sign in" do
        let(:action) { post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]}
      end
    end
    context "with queue items that do not belongs to the current user" do
      it "does not change the queue items" do
        billy = Fabricate(:user)
        set_current_user(billy)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: billy, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end

    end
  end

end