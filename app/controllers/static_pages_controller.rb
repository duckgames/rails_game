class StaticPagesController < ApplicationController
    def home
        if current_user.empire
          @empire = current_user.empire
        else
          redirect_to new_empire_url
        end
      end
end
