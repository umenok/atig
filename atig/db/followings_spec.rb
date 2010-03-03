#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'atig/db/followings'

describe Atig::Db::Followings,"when updated users" do
  def user(name, protect, only)
    user = stub('User')
    user.stub!(:screen_name).and_return(name)
    user.stub!(:protected).and_return(protect)
    user.stub!(:only).and_return(only)
    user
  end

  before do
    @alice    = user 'alice'   , false, false
    @bob      = user 'bob'     , true , false
    @charriey = user 'charriey', false, true

    @db = Atig::Db::Followings.new
    @db.update [ @alice, @bob ]

    @listen = {}
    @db.listen do|kind, users|
      @listen[kind] = users
    end
  end

  it "should call listener with :join" do
    @db.update [ @alice, @bob, @charriey ]
    @listen[:join].should == [ @charriey ]
    @listen[:bye ].should == nil
    @listen[:mode].should == nil
  end

  it "should call listener with :bye" do
    @db.update [ @alice ]
    @listen[:join].should == nil
    @listen[:bye ].should == [ @bob ]
    @listen[:mode].should == nil
  end

  it "should call listener with :mode" do
    bob = user 'bob', false, false

    @db.update [ @alice, bob ]
    @listen[:join].should == nil
    @listen[:bye ].should == nil
    @listen[:mode].should == [ bob ]
  end

  it "should have users" do
    @db.users.should == [ @alice, @bob ]
  end
end
