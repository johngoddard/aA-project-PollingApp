class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :not_duplicate_response, :not_poll_author

    belongs_to :respondent,
      primary_key: :id,
      foreign_key: :user_id,
      class_name: :User

    belongs_to :answer_choice,
      primary_key: :id,
      foreign_key: :answer_choice_id,
      class_name: :AnswerChoice

    has_one :question,
      through: :answer_choice,
      source: :question

  def sibling_responses
    self.question.responses.where.not(id: self.id)

    Question.joins(answer_choices: [:responses])
             .where('answer_choices.id' => self.answer_choice_id,
                    'responses.user_id' => self.user_id)
  end

  def respondent_already_answered?
    # sibling_responses.any?{|response| response.user_id == self.user_id}
    # sibling_responses.where(user_id: self.user_id).length > 0
    AnswerChoice.joins(:responses)
             .where('answer_choices.id' => self.answer_choice_id,
                    'responses.user_id' => self.user_id)
            .length > 0
  end

  def not_duplicate_response
    if respondent_already_answered?
      self.errors[:user_id] << "already answered this question"
    end
  end

  def get_poll_author_id
    Poll.joins(questions: [:answer_choices])
        .where('answer_choices.id' => self.answer_choice_id)
        .first
        .author_id
  end

  def not_poll_author
    if get_poll_author_id == self.user_id
      self.errors[:user_id] << "authored this question"
    end
  end


end
