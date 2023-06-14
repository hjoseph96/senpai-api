class HelloController < ApplicationController
    def hi_senpai
        render json: { success: 'You noticed me, Senpai!' }
    end
end