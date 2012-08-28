require 'test_helper'

class BookmarkTest < ActiveSupport::TestCase
  def setup
  end


  test 'cannot create with video without user' do
    video = videos(:charlie_bit_my_finger)
    assert_no_difference 'Bookmark.count' do
      bookmark = Bookmark.create video: video
      assert_nil bookmark.created_at
    end
  end
  
  test 'cannot create without video with user' do
    alice = users :alice
    assert_no_difference 'Bookmark.count' do
      bookmark = Bookmark.create user: alice
      assert_nil bookmark.created_at
    end
  end
  
  test 'can create with video with user' do
    video = videos(:charlie_bit_my_finger)
    alice = users :alice
    assert_difference 'Bookmark.count' do
      bookmark = Bookmark.create video: video, user: alice
      assert_not_nil bookmark.created_at
    end
  end
  
  test 'can destroy' do
    video = videos(:charlie_bit_my_finger)
    alice = users :alice
    bookmark = Bookmark.create video: video, user: alice
    assert_not_nil bookmark.created_at
    
    assert_difference 'Bookmark.count', -1 do
      bookmark.destroy
    end
    assert_equal 0, Bookmark.where(id: bookmark.id).count
  end
end
