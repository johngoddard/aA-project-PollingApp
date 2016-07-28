class Question < ActiveRecord::Base

  validates :poll_id, :text, presence: true

  has_many :answer_choices,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: :AnswerChoice

  belongs_to :poll,
    primary_key: :id,
    foreign_key: :poll_id,
    class_name: :Poll

  has_many :responses,
    through: :answer_choices,
    source: :responses


  def slow_results
    choices = Hash.new

    self.answer_choices.each do |choice|
      choices[choice.text] = choice.responses.length
    end

    choices
  end

  def better_results
    choices = Hash.new

    choices_with_respones = self.answer_choices.includes(:responses)

    choices_with_respones.each do |choice|
      choices[choice.text] = choice.responses.length
    end
    choices
  end

  def results
    choices_with_count = self
      .answer_choices
      .select("answer_choices.*, COUNT(responses.id) AS num_responses")
      .joins(" LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
      .where(question_id: self.id)
      .group("answer_choices.id")

    choices_with_count.map{|c| [c.text, c.num_responses]}.to_h
  end
end
