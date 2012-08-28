require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  end


  def generate_email_addr
    "chunky+#{Time.now.to_i}@bacon.com"
  end

  #test 'finds existing user by fb_uid' do
  #  alice = users(:alice)
  #  
  #  user = User.find_or_create_from_facebook_info alice.fb_uid, alice.fb_access_token
  #  assert_equal alice.id, user.id
  #  assert_equal alice.name, user.name
  #  assert_equal alice.fb_access_token, user.fb_access_token
  #end

  test 'finds existing user by id' do
    alice = users(:alice)
    
    user = User.find 'alice00'
    assert_equal alice.id, user.id
    assert_equal alice.full_name, user.full_name
    assert_equal alice.fb_access_token, user.fb_access_token
  end

  #test 'finds existing contact by fb_uid and migrates to user' do
  #  chris = Contact.first #users(:chris).become(Contact)
  #  assert_nil chris.fb_access_token
  #  
  #  user = User.find_or_create_from_facebook_info chris.fb_uid, 'abcdef'
  #  assert_equal chris.id, user.id
  #  assert_equal chris.name, user.name
  #  assert_equal 'abcdef', user.fb_access_token
  #end

  test 'can create' do
    user = nil
    assert_difference 'User.count' do
      user = User.create email: generate_email_addr
    end
    assert_not_nil user
    assert_not_nil user.id
    assert_not_nil user.created_at
  end
  
  test 'cannot create with duplicate email address' do
    user1 = nil
    email_addr = generate_email_addr
    assert_difference 'User.count' do
      user1 = User.create email: email_addr
    end
    assert_not_nil user1
    assert_not_nil user1.id
    assert_not_nil user1.created_at

    user2 = nil
    assert_no_difference 'User.count' do
      user2 = User.create email: email_addr
    end
    assert_not_nil user2
    assert_not_nil user2.id
    assert_nil user2.created_at
  end

  test 'can update name' do
    alice = users(:alice)
    assert_equal 'Alice', alice.first_name

    alice.first_name = 'Jane'
    assert_nothing_raised do
      alice.save!
    end
    assert_equal 'Jane', User.find(alice.id).first_name
  end
  
  #test 'update attributes from facebook' do
  #  alice = users(:alice)
  #  assert_equal 'Alice Anderson' , alice.name
  #  
  #  alice.update_attributes :first_name => 'Julie', :last_name => 'Johnson'
  #  alice.reload
  #  assert_equal 'Julie Johnson' , alice.name
  #  
  #  alice.update_attributes_from_facebook_sync!
  #  alice.reload
  #  assert_equal 'Alice Anderson' , alice.name
  #end
  
  #test 'update contacts from facebook' do
  #  alice = users(:alice)
  #  assert_equal 2, alice.contacts.count
  #  
  #  # change contact's name:
  #  chris = Contact.find alice.contacts.first.id
  #  assert_equal 'Chris Cooper', chris.name
  #  
  #  chris.update_attributes :first_name => 'Mickey', :last_name => 'Mouse'
  #  chris.reload
  #  assert_equal 'Mickey Mouse', chris.name
  #  
  #  # add contact:
  #  jim = alice.contacts.create :first_name => 'Jim', :last_name => 'Jellybean'
  #  assert_not_nil jim.id
  #  assert_equal 'Jim Jellybean', jim.name
  #  assert_equal 3, alice.contacts.count
  #  
  #  # sync contacts with facebook:
  #  alice.update_contacts_from_facebook_sync!
  #
  #  # validate that chris's name has reverted:
  #  chris.reload
  #  assert_equal 'Chris Cooper', chris.name
  #
  #  # validate that Jim Jellybean is no longer a contact:
  #  assert_equal 2, alice.contacts.count
  #  assert_equal 'Chris Bob', alice.contacts.map(&:first_name).join(' ')
  #end

  test 'responds to full_name' do
    user = User.create email: generate_email_addr, first_name: 'Chunky', last_name: 'Bacon'
    assert_not_nil user.created_at
    assert_equal 'Chunky Bacon', user.full_name
  end

  test 'can destroy' do
    user = User.create email: generate_email_addr
    assert_not_nil user.created_at
    assert_equal 1, User.where(id: user.id).count
    assert_not_nil User.find(user.id)
    
    assert_difference 'User.count', -1 do
      user.destroy
    end
    assert_equal 0, User.where(id: user.id).count
  end
end
