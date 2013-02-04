require 'spec_helper'

describe BookController do

  describe "GET 'title:string'" do
    it "returns http success" do
      get 'title:string'
      response.should be_success
    end
  end

  describe "GET 'number:integer'" do
    it "returns http success" do
      get 'number:integer'
      response.should be_success
    end
  end

  describe "GET 'author:string'" do
    it "returns http success" do
      get 'author:string'
      response.should be_success
    end
  end

  describe "GET 'release_date:date'" do
    it "returns http success" do
      get 'release_date:date'
      response.should be_success
    end
  end

  describe "GET 'size:integer'" do
    it "returns http success" do
      get 'size:integer'
      response.should be_success
    end
  end

  describe "GET 'downloads:integer'" do
    it "returns http success" do
      get 'downloads:integer'
      response.should be_success
    end
  end

  describe "GET 'lang:string'" do
    it "returns http success" do
      get 'lang:string'
      response.should be_success
    end
  end

end
