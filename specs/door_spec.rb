require_relative 'spec_helper'
require_relative '../door'

describe Door do
  before(:each) do
    @door = Door.new
  end

  describe "#initialize" do

    it "must create an instance of Door" do
        @door.must_be_instance_of(Door)
    end

    it "should say if a Door is open" do
      @door.must_respond_to(:opened)
    end

    it "should say if a Door is locked" do
      @door.must_respond_to(:locked)
    end

    # Note: this seems unelegant if the inscription is blank, but
    # most of the other things I tried had other problems (harder
    # to edit, difficult to test without entanglements with other
    # tests, etc.)
    it "should say if there is writing on the Door" do
      @door.must_respond_to(:inscription)
    end

  end

  describe "#inscribe(words)" do
    it "should allow someone to write on a blank door" do
      @door.inscribe("something")
      @door.inscription.must_equal("something")
    end

    it "should prevent writing on a door with something on it" do
      @door.inscribe("something")
      proc { @door.inscribe("something else") }.must_raise(RuntimeError)
    end

    # Question: is there a way to condense these tests to a single test?
    # I tried doing an each loop, but since it's working with the same
    # instance each time, it breaks because you can only inscribe
    # something once per instance.
    it "should return a string if a Fixnum is passed in" do
      door_fixnum = @door.inscribe(1)
      door_fixnum.must_be_instance_of(String)
    end

    it "should return a string if a Float is passed in" do
      door_float = @door.inscribe(1.5)
      door_float.must_be_instance_of(String)
    end

    it "should return a string if a Symbol is passed in" do
      door_sym = @door.inscribe(:something)
      door_sym.must_be_instance_of(String)
    end

    # I did these tests because I was playing around in irb and noticed
    # that if I did not convert properly, using 1 as an argument would
    # return "\u0001". The others return TypeError messages, so this
    # probably isn't a useful test for these.
    it "should return the same Fixnum as a string" do
      door_fixnum = @door.inscribe(1)
      door_fixnum.to_i.must_equal(1)
    end

    it "should return the same Float as a string" do
      door_float = @door.inscribe(1.5)
      door_float.to_f.must_equal(1.5)
    end

    it "should return the same Symbol as a string" do
      door_sym = @door.inscribe(:something)
      door_sym.to_sym.must_equal(:something)
    end
  end

  describe "#open_door" do
    it "must open a closed door" do
      @door.open_door
      @door.opened.must_equal(true)
    end

    it "should not allow a user to open a locked door" do
      @door.lock_door
      proc {@door.open_door}.must_raise(RuntimeError)
    end

    it "should not allow a user to open a door that's already open" do
      @door.open_door
      proc { @door.open_door }.must_raise(RuntimeError)
    end
  end

  describe "#lock_door" do
    it "must lock an unlocked door" do
      @door.lock_door
      @door.locked.must_equal(true)
    end

    # My reasoning:
    # If the lock is a deadbolt and the door is open,
    # locking a deadbolt does not really lock the
    # door. If anything, since it prevents the door from
    # closing, it's worse than unlocked.
    # If the lock is not a deadbolt, locking such a door
    # has other consequences: you might get locked out of
    # of a room with no way of getting back in, for example,
    # or the lock mechanism might prevent you from locking
    # an open door in the first place, as many often do.
    it "should not lock an open door" do
      @door.open_door
      proc { @door.lock_door }.must_raise(RuntimeError)
    end

    it "should not lock a door that is already locked" do
      @door.lock_door
      proc { @door.lock_door }.must_raise(RuntimeError)
    end
  end

  describe "#close_door" do
    it "must close an open door" do
      @door.open_door
      @door.close_door.must_equal(false)
    end

    it "must not close a door that is already closed" do
      proc { @door.close_door }.must_raise(RuntimeError)
    end
  end

  describe "#unlock_door" do
    it "must unlock a locked door" do
      @door.lock_door
      @door.unlock_door
      @door.locked.must_equal(false)
    end

    it "should not unlock a door that is unlocked" do
      proc {@door.unlock_door}.must_raise(RuntimeError)
    end
  end

end
