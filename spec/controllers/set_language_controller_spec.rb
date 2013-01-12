require 'spec_helper'

describe SetLanguageController do

  describe "GET 'english'" do
    it "returns http success" do
      get 'english'
      response.should be_success
    end
  end

  describe "GET 'persian'" do
    it "returns http success" do
      get 'persian'
      response.should be_success
    end
  end

end
