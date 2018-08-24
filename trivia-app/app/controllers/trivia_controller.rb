class TriviaController < ApplicationController
  before_action :authorized
  def index
    @trivia = Trivium.where("id NOT in (?)", current_user.trivia.pluck(:id))
  end

  def show
    @trivia = Trivium.find(params[:id])
    @answer = Answer.new
  end

  def trivia_answer
    @answer = Answer.find(params["answer"]["answer"])
    trivia = Trivium.find(@answer.trivium_id)
    TriviaUser.create(user_id: current_user.id,trivia_id: trivia.id)

    if @answer.is_correct
      # byebug

      if trivia.difficulty == "easy"
        current_user.update(score: current_user.score+50)
      elsif trivia.difficulty == "medium"
        current_user.update(score: current_user.score+100)
      else trivia.difficulty == "hard"
        current_user.update(score: current_user.score+200)
      end
    end
  end

  def new
    @trivium = Trivium.new
  end

  def create
    @trivium = Trivium.new  (trivia_params)
    if @trivium.save
      answer_params.values.each do |hash|
        ans = Answer.new(hash)
        ans.trivium_id = @trivium.id
        if ans.is_correct.nil?
          ans.is_correct = false
        end
        ans.save
      end
      redirect_to trivium_path(@trivium)
    else

      redirect_to new_trivium_path
    end
  end

  def edit
    @trivium = Trivium.find(params[:id])
  end

  def update
    @trivium = Trivium.find(params[:id])
    if @trivium.update(trivia_params)
      @trivium.answers.each{|x| x.delete}
      @trivium.save
      answer_params.values.each do |hash|
        ans = Answer.new(hash)
        ans.trivium_id = @trivium.id
        if ans.is_correct.nil?
          ans.is_correct = false
        end
        ans.save
      end
      redirect_to trivium_path(@trivium)
    else
      redirect_to edit_trivium_path(@trivium)
    end
  end

  def destroy
    trivium = Trivium.find(params["id"])
    trivium.delete

    redirect_to trivia_path
  end

  private
  def trivia_params
    params.require("trivium").permit(:question, :difficulty, :category_id)
  end

  def answer_params
    params.require("trivium").require("answers").permit!
  end

end
