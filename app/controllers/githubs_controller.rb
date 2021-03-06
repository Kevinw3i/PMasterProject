require "github.rb"

class GithubsController < ApplicationController
    def index
        if params["code"].present?
            access_token = Github.new.gettoken(params["code"])

            # DB
            # puts "這是寫入 User:"
            # puts current_user.id

            @user = Gittoke.find_by("user_id = ?", current_user.id)
            if @user != nil
                if @user.token != access_token
                    @user.token = access_token

                    @user.save
                end
            else
                @user = Gittoke.new
                @user.token = access_token
                @user.user_id = current_user.id

                @user.save
            end
        
            # for test
            puts "這是寫入 Session:"
            session[:user] = access_token
            puts "這是session[:user] 當前的值："
            puts session[:user]

            @checkOA = true
            redirect_to "/repositories"
        else
            redirect_to "/"
        end
    end
end