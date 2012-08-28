require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def setup
  end


  test 'can create' do
    video = nil
    assert_difference 'Video.count' do
      video = Video.create html: 'not blank', host_url: 'http://chunky/bacon'
    end
    assert_not_nil video
    assert_not_nil video.id
    assert_not_nil video.created_at
  end
  
  test 'can destroy' do
      video = Video.create html: 'not blank', host_url: 'http://chunky/bacon'
    assert_not_nil video.created_at
    assert_equal 1, Video.where(id: video.id).count
    assert_not_nil Video.find video.id
    
    assert_difference 'Video.count', -1 do
      video.destroy
    end
    assert_equal 0, Video.where(id: video.id).count
  end
  
  test 'finds existing video by id' do
    charlie = videos(:charlie_bit_my_finger)
    
    video = Video.find 'charlie'
    assert_equal charlie.id, video.id
    assert_equal charlie.title, video.title
  end

  #test 'find_or_create_by_attributes with video returns video' do
  #  charlie_bit_my_finger = videos(:charlie_bit_my_finger)
  #  
  #  video = Video.find_or_create_by_attributes charlie_bit_my_finger
  #  assert_equal charlie_bit_my_finger, video
  #end
  #
  #test 'find_or_create_by_attributes with id returns video with matching id' do
  #  charlie_bit_my_finger = videos(:charlie_bit_my_finger)
  #  
  #  video = Video.find_or_create_by_attributes :id => charlie_bit_my_finger.id
  #  assert_equal charlie_bit_my_finger, video
  #end
  #
  #test 'find_or_create_by_attributes with host_url returns video with matching host_url' do
  #  charlie_bit_my_finger = videos(:charlie_bit_my_finger)
  #  
  #  video = Video.find_or_create_by_attributes :host_url => charlie_bit_my_finger.host_url
  #  assert_equal charlie_bit_my_finger, video
  #end
  #
  #test 'find_or_create_by_attributes without params raises ActiveRecord::RecordNotFound exception' do
  #  assert_raise ActiveRecord::RecordNotFound do
  #    Video.find_or_create_by_attributes :chunky => 'bacon'
  #  end
  #end
  #
  #test 'find_or_create_by_attributes with new host_url creates new video' do
  #  roygbiv_url = 'http://www.youtube.com/watch?v=Gf33ueRXMzQ'
  #
  #  video = nil
  #  assert_difference 'Video.count' do
  #    video = Video.find_or_create_by_attributes :host_url => roygbiv_url
  #  end
  #end
end
